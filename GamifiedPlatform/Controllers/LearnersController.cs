using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using GamifiedPlatform.Models;
using System.Reflection;
using Microsoft.Extensions.Hosting;

namespace GamifiedPlatform.Controllers
{
    public class LearnersController : Controller
    {
        private readonly GamifiedPlatformContext _context;

        public LearnersController(GamifiedPlatformContext context)
        {
            _context = context;
        }

        public IActionResult Dashboard(int id)
        {
            var learner = _context.Learners
                .FirstOrDefault(l => l.UserId == id);

            if (learner == null)
            {
                return NotFound();
            }

            return View(learner);
        }

        public async Task<IActionResult> ViewActiveQuestParticipants(int learnerId)
        {
            // Fetch the active quest ID for the learner
            var activeQuestId = await _context.LearnersCollaborations
                .Where(lc => lc.LearnerId == learnerId)
                .Select(lc => lc.QuestId)
                .FirstOrDefaultAsync();

            if (activeQuestId == 0)
            {
                TempData["ErrorMessage"] = "No active quests found for this learner.";
                return RedirectToAction("Profile", new { id = learnerId });
            }

            // Get all participants in the same active quest
            var participants = await _context.LearnersCollaborations
                .Where(lc => lc.QuestId == activeQuestId)
                .Select(lc => new
                {
                    LearnerId = lc.Learner.LearnerId,
                    FullName = lc.Learner.FirstName + " " + lc.Learner.LastName,
                    Email = lc.Learner.Email
                })
                .ToListAsync();

            ViewBag.LearnerId = learnerId;
            return View(participants); // Ensure you have a corresponding Razor view for this action
        }

        public IActionResult Profile(int id)
        {
            var learner = _context.Learners.FirstOrDefault(l => l.UserId == id);
            if (learner == null)
            {
                return NotFound();
            }

            return View(learner);
        }

        // AddPost
        public async Task<IActionResult> AddPost(int learnerID, int forumID, string post)
        {
            var learner = await _context.Learners.FirstOrDefaultAsync(l => l.LearnerId == learnerID);
            if (learner == null)
            {
                return RedirectToAction("Profile");
            }

            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($"Exec Post @LearnerID={learnerID}, @DiscussionID={forumID}, @Post={post}");
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("FOREIGN KEY constraint"))
                {
                    var learnerExists = await _context.Learners.AnyAsync(d => d.LearnerId == learnerID);
                    var forumExists = await _context.DiscussionForums.AnyAsync(d => d.ForumId == forumID);
                    if (!learnerExists && !forumExists)
                    {
                        ModelState.AddModelError("", "The specified Learner and Forum do not exist.");
                    }
                    else if (!learnerExists) ModelState.AddModelError("", "The specified Learner does not exist.");
                    else ModelState.AddModelError("", "The specified Forum does not exist.");
                }
                else if (ex.Message.Contains("PRIMARY KEY constraint"))
                {
                    ModelState.AddModelError("", "This post already added");
                }
                else
                {
                    ModelState.AddModelError("", "An error occurred while adding the post. Please try again.");
                }
                return View("Profile", learner);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "An unexpected error occurred: " + ex.Message);
                return View("Profile", learner);
            }

            TempData["SuccessMessage"] = "Post added successfully!";
            return View("Profile", learner);
        }

        public IActionResult Modules(int courseId)
        {
            var courseIdParam = new SqlParameter("@courseID", courseId);
            var modules = _context.Modules
                .FromSqlRaw("EXEC ModuleDifficulty @courseID", courseIdParam)
                .ToList();

            var enrollment = _context.CourseEnrollments.FirstOrDefault(ce => ce.CourseId == courseId);
            if (enrollment != null)
            {
                var learner = _context.Learners.FirstOrDefault(l => l.LearnerId == enrollment.LearnerId);
                if (learner != null)
                {
                    ViewBag.UserId = learner.UserId;
                }
            }

            return View(modules);
        }

        public async Task<IActionResult> AddGoal(int learnerID, int goalID)
        {
            var learner = await _context.Learners.FirstOrDefaultAsync(l => l.LearnerId == learnerID);
            if (learner == null)
            {
                TempData["ErrorMessage"] = "The specified learner does not exist.";
                return RedirectToAction("Profile");
            }

            try
            {
                await _context.Database.ExecuteSqlInterpolatedAsync($"Exec AddGoal @learnerID={learnerID}, @goalID={goalID}");
            }
            catch (SqlException ex)
            {
                if (ex.Message.Contains("FOREIGN KEY constraint"))
                {
                    var learnerExists = await _context.Learners.AnyAsync(d => d.LearnerId == learnerID);
                    if (!learnerExists)
                    {
                        ModelState.AddModelError("", "The specified learner does not exist.");
                    }
                    else
                    {
                        ModelState.AddModelError("", "The specified goal does not exist.");
                    }
                }
                else if (ex.Message.Contains("PRIMARY KEY constraint"))
                {
                    ModelState.AddModelError("", "This goal already specified.");
                }
                else
                {
                    ModelState.AddModelError("", "An error occurred while specifying the goal. Please try again.");
                }
                return View("Profile", learner);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("", "An unexpected error occurred: " + ex.Message);
                return View("Profile", learner);
            }

            TempData["SuccessMessage"] = "Goal added successfully.";
            return View("Profile", learner);
        }

        private bool LearnerExists(int id)
        {
            return _context.Learners.Any(e => e.LearnerId == id);
        }
    }
}
