﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using projectt.Models;

namespace projectt.Controllers
{
    public class DiscussionForumsController : Controller
    {
        private readonly GamifiedPlatformContext _context;

        public DiscussionForumsController(GamifiedPlatformContext context)
        {
            _context = context;
        }

        // GET: DiscussionForums
        public async Task<IActionResult> Index()
        {
            var Forums = await _context.DiscussionForums.FromSqlRaw("Exec getAllForums").ToListAsync();
            return View(Forums);
        }

        // GET: DiscussionForums/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var discussionForum = await _context.DiscussionForums
                .Include(d => d.Module)
                .FirstOrDefaultAsync(m => m.ForumId == id);
            if (discussionForum == null)
            {
                return NotFound();
            }

            return View(discussionForum);
        }

        // GET: DiscussionForums/Create
        public IActionResult Create()
        {
            ViewData["ModuleId"] = new SelectList(_context.Modules, "ModuleId", "ModuleId");
            return View();
        }

        // POST: DiscussionForums/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(int moduleID,int courseID,string title,string description)
        {
            await _context.Database.ExecuteSqlInterpolatedAsync($"Exec CreateDiscussion @ModuleID={moduleID},@courseID={ courseID},@title={title},@description={description}");
            
            return RedirectToAction("Index");
        }
       
        // GET: DiscussionForums/Edit/5

        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var discussionForum = await _context.DiscussionForums.FindAsync(id);
            if (discussionForum == null)
            {
                return NotFound();
            }
            ViewData["ModuleId"] = new SelectList(_context.Modules, "ModuleId", "ModuleId", discussionForum.ModuleId);
            return View(discussionForum);
        }

        // POST: DiscussionForums/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("ForumId,ModuleId,CourseId,Title,LastActive,Timestamp,Description")] DiscussionForum discussionForum)
        {
            if (id != discussionForum.ForumId)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(discussionForum);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!DiscussionForumExists(discussionForum.ForumId))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["ModuleId"] = new SelectList(_context.Modules, "ModuleId", "ModuleId", discussionForum.ModuleId);
            return View(discussionForum);
        }

        // GET: DiscussionForums/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var discussionForum = await _context.DiscussionForums
                .Include(d => d.Module)
                .FirstOrDefaultAsync(m => m.ForumId == id);
            if (discussionForum == null)
            {
                return NotFound();
            }

            return View(discussionForum);
        }

        // POST: DiscussionForums/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var discussionForum = await _context.DiscussionForums.FindAsync(id);
            if (discussionForum != null)
            {
                _context.DiscussionForums.Remove(discussionForum);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool DiscussionForumExists(int id)
        {
            return _context.DiscussionForums.Any(e => e.ForumId == id);
        }
    }
}
