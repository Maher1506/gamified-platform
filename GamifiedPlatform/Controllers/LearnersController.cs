﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using GamifiedPlatform.Models;

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

        public IActionResult ViewAssessments(int learnerId)
        {
            // Prepare the SQL parameter
            var learnerIdParam = new SqlParameter("@LearnerID", learnerId);

            // Execute the stored procedure and get the list of assessments
            var assessments = _context.Assessments
                .FromSqlRaw("EXEC AssessmentAnalysis @LearnerID", learnerIdParam)
                .ToList();

            // Pass the learnerId to ViewBag for the "Back to Profile" button
            ViewBag.UserId = learnerId;

            // Pass the assessments data to the view
            return View(assessments);
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

        public IActionResult Modules(int courseId)
        {
            // Create the SQL parameter for the stored procedure
            var courseIdParam = new SqlParameter("@courseID", courseId);

            // Execute the stored procedure to get modules for the course
            var modules = _context.Modules
                .FromSqlRaw("EXEC ModuleDifficulty @courseID", courseIdParam)
                .ToList();

            // Retrieve the LearnerId from the Course_enrollment table based on the courseId
            var enrollment = _context.CourseEnrollments
                .FirstOrDefault(ce => ce.CourseId == courseId);

            // If enrollment is found, get the corresponding Learner and UserId
            if (enrollment != null)
            {
                var learner = _context.Learners
                    .FirstOrDefault(l => l.LearnerId == enrollment.LearnerId);

                if (learner != null)
                {
                    // Set the UserId in ViewBag to be used in the view
                    ViewBag.UserId = learner.UserId;
                }
            }

            return View(modules);
        }

        public IActionResult EnrolledCourses(int id)
        {
            var learner = _context.Learners.FirstOrDefault(l => l.UserId == id);
            if (learner == null)
            {
                return NotFound();
            }

            ViewBag.UserId = id;

            var learnerIdParam = new SqlParameter("@LearnerID", learner.LearnerId);

            // Execute the stored procedure and map the result to the Course entity
            var enrolledCourses = _context.Courses
                .FromSqlRaw("EXEC EnrolledCourses @LearnerID", learnerIdParam)
                .ToList();

            return View(enrolledCourses);
        }




        // GET: Learners
        public async Task<IActionResult> Index()
        {
            return View(await _context.Learners.ToListAsync());
        }

        // GET: Learners/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var learner = await _context.Learners
                .FirstOrDefaultAsync(m => m.LearnerId == id);
            if (learner == null)
            {
                return NotFound();
            }

            return View(learner);
        }
       
            // GET: Learners/Create
            public IActionResult Create()
        {
            return View();
        }
        
        // POST: Learners/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("LearnerId,FirstName,LastName,Gender,BirthDate,Country,CulturalBackground")] Learner learner)
        {
            if (ModelState.IsValid)
            {
                _context.Add(learner);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(learner);
        }



        // GET: Learners/Edit/5
        [HttpGet]
        public IActionResult Edit(int id)
        {
            var learner = _context.Learners.FirstOrDefault(l => l.LearnerId == id);
            if (learner == null)
            {
                return NotFound();
            }
            return View(learner);
        }

        // This action will save the edited profile
        [HttpPost]
        public IActionResult Edit(Learner learner)
        {
            if (ModelState.IsValid)
            {
                // Save the learner details to the database
                _context.Update(learner);
                _context.SaveChanges();

                // Redirect to the profile page after saving
                return RedirectToAction("Profile", new { id = learner.LearnerId });
            }

            // If the model state is invalid, return the view with the model data so that validation errors are shown
            return View(learner);
        }


        // GET: Learners/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var learner = await _context.Learners
                .FirstOrDefaultAsync(m => m.LearnerId == id);
            if (learner == null)
            {
                return NotFound();
            }

            return View(learner);
        }

        // POST: Learners/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var learner = await _context.Learners.FindAsync(id);
            if (learner != null)
            {
                _context.Learners.Remove(learner);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool LearnerExists(int id)
        {
            return _context.Learners.Any(e => e.LearnerId == id);
        }
    }
}
