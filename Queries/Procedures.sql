USE GamifiedPlatform
GO

-- =============================================

GO
CREATE PROC PostINS (@instructorID INT, @DiscussionID INT, @Post VARCHAR(MAX))
AS
BEGIN
    INSERT INTO InstructorDiscussion (ForumID, InstructorID, Post, time)
    VALUES (@DiscussionID, @instructorID, @Post, GETDATE());
END

-- =============================================

GO
CREATE PROC getAllGoals
AS
SELECT *
FROM Learning_goal

-- =============================================

GO
CREATE PROC getAllLeaderBoards
AS
SELECT *
FROM Leaderboard

-- =============================================

GO
CREATE PROC getSpecificLearnerGoals (@learnerID INT)
AS
SELECT *
FROM LearnersGoals
WHERE LearnerID = @learnerID

-- =============================================

GO
CREATE PROC markAsRead (@notificationID INT)
AS
BEGIN
    UPDATE Notification
    SET urgency_level = 'read'
    WHERE ID = @notificationID
END

-- =============================================

GO
CREATE PROCEDURE ViewNotAdmin (@adminID AS INT)
AS
BEGIN
    SELECT Notification.ID, Notification.message, Notification.urgency_level, Notification.timestamp
    FROM Notification
    INNER JOIN ReceivedNotification 
        ON ReceivedNotification.NotificationID = Notification.ID 
        AND ReceivedNotification.adminID = @adminID
END

-- =============================================

GO
CREATE PROCEDURE DeleteLearner @LearnerID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UserID INT;

        SELECT @UserID = UserID 
        FROM Learner 
        WHERE LearnerID = @LearnerID;

        IF @UserID IS NULL
        BEGIN
            PRINT 'Learner does not exist.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM Learner WHERE LearnerID = @LearnerID;
        DELETE FROM Users WHERE UserID = @UserID;

        COMMIT TRANSACTION;
        PRINT 'Learner and corresponding user deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error occurred during deletion: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END

-- =============================================

GO
CREATE PROCEDURE DeleteInstructor @InstructorID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @UserID INT;

        SELECT @UserID = UserID 
        FROM Instructor 
        WHERE InstructorID = @InstructorID;

        IF @UserID IS NULL
        BEGIN
            PRINT 'Instructor does not exist.';
            ROLLBACK TRANSACTION;
            RETURN;
        END

        DELETE FROM Instructor WHERE InstructorID = @InstructorID;
        DELETE FROM Users WHERE UserID = @UserID;

        COMMIT TRANSACTION;
        PRINT 'Instructor and corresponding user deleted successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Error occurred during deletion: ' + ERROR_MESSAGE();
        THROW;
    END CATCH
END

-- =============================================

GO
CREATE PROCEDURE updateLearnerInfo
    @learnerID INT,
    @firstName VARCHAR(50),
    @lastName VARCHAR(50),
    @country VARCHAR(50),
    @email VARCHAR(50),
    @cultural_background VARCHAR(50),
    @profilePicturePath NVARCHAR(MAX)
AS
BEGIN
    UPDATE Learner
    SET 
        first_name = @firstName,
        last_name = @lastName,
        country = @country,
        email = @email,
        cultural_background = @cultural_background,
        ProfilePicturePath = @profilePicturePath
    WHERE LearnerID = @learnerID
END

-- =============================================

GO
CREATE PROC getCurrentLearnerPassword (@learnerID INT, @password VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT @password = u.Password
    FROM Learner l
    INNER JOIN Users u ON l.UserID = u.UserID
    WHERE l.LearnerID = @learnerID
END

-- =============================================

GO
CREATE PROC AllLearnersInfo
AS
BEGIN
    SELECT *
    FROM PersonalizationProfiles
END

-- =============================================

GO
CREATE PROC getAllForums
AS
BEGIN
    SELECT *
    FROM Discussion_forum
END

-- =============================================

GO
CREATE PROC monitorSpecificPath (@learnerID INT)
AS
BEGIN
    SELECT *
    FROM Learning_path
    WHERE LearnerID = @learnerID
END

-- =============================================

GO
CREATE PROC getUserInfo (@UserID INT)
AS
BEGIN
    SELECT *
    FROM users
    WHERE UserID = @UserID
END

-- =============================================

GO
CREATE PROC updateUserInfo (
    @UserID INT,
    @name VARCHAR,
    @email VARCHAR,
    @phone VARCHAR,
    @address VARCHAR
)
AS
BEGIN
    UPDATE users
    SET 
        Name = @name,
        Email = @email,
        Phone = @phone,
        Address = @address
    WHERE UserID = @UserID
END

-- =============================================

GO
CREATE PROCEDURE updateInstructorInfo
    @InstructorID INT,
    @Name VARCHAR(50) = NULL,
    @LatestQualification VARCHAR(50) = NULL,
    @ExpertiseArea VARCHAR(50) = NULL,
    @Email VARCHAR(50) = NULL,
    @ProfilePicturePath VARCHAR(100) = NULL
AS
BEGIN
    UPDATE Instructor
    SET 
        Name = ISNULL(@Name, Name),
        Latest_Qualification = ISNULL(@LatestQualification, Latest_Qualification),
        Expertise_Area = ISNULL(@ExpertiseArea, Expertise_Area),
        Email = ISNULL(@Email, Email),
        ProfilePicturePath = ISNULL(@ProfilePicturePath, ProfilePicturePath)
    WHERE InstructorID = @InstructorID
END

-- =============================================

GO
CREATE PROCEDURE ViewPersonalizationProfiles (@LearnerID INT)
AS
BEGIN
    SELECT *
    FROM PersonalizationProfiles p
    WHERE p.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE DeletePersonalizationProfile (@ProfileID INT)
AS
BEGIN
    DELETE
    FROM PersonalizationProfiles
    WHERE ProfileID = @ProfileID
END

-- test
select * from PersonalizationProfiles
exec DeletePersonalizationProfile 104

-- =============================================

GO
CREATE PROCEDURE ViewInfo (@LearnerID INT)
AS
BEGIN
    SELECT *
    FROM Learner
    WHERE LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE LearnerInfo (@LearnerID INT)
AS
BEGIN
    SELECT *
    FROM PersonalizationProfiles
    WHERE LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE EmotionalState (@LearnerID INT)
AS
BEGIN
    SELECT TOP 1 emotional_state
    FROM Emotional_feedback e
    WHERE e.LearnerID = @LearnerID
    ORDER BY timestamp DESC
END

-- =============================================

GO
CREATE PROCEDURE LogDetails (@LearnerID INT)
AS
BEGIN
    SELECT *
    FROM Interaction_log i
    WHERE i.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE InstructorReview (@InstructorID INT)
AS
BEGIN
    SELECT *
    FROM Emotionalfeedback_review e
    WHERE e.InstructorID = @InstructorID
END

-- =============================================

GO
CREATE PROCEDURE CourseRemove (@courseID INT)
AS
BEGIN
    DELETE FROM Course
    WHERE CourseID = @courseID
END

-- =============================================

GO
CREATE PROCEDURE HighestGrade (@CourseId INT)
AS
BEGIN
    SELECT TOP 1
        a.ID AS AssessmentId,
        a.Title AS AssessmentTitle,
        a.total_marks AS HighestGrade
    FROM Assessments a
    WHERE a.CourseID = @CourseId
    ORDER BY a.total_marks DESC
END

-- =============================================

GO
CREATE PROCEDURE InstructorCount
AS
BEGIN
    SELECT *
    FROM Course
END

-- =============================================

GO
CREATE PROCEDURE ViewNot (@LearnerID INT)
AS
BEGIN
    SELECT Notification.ID, Notification.message, Notification.urgency_level, Notification.timestamp
    FROM Notification
    INNER JOIN ReceivedNotification 
        ON ReceivedNotification.NotificationID = Notification.ID 
        AND ReceivedNotification.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE CreateDiscussion (
    @ModuleID INT,
    @courseID INT,
    @title VARCHAR(50),
    @description VARCHAR(50)
)
AS
BEGIN
    INSERT INTO Discussion_forum (ModuleID, CourseID, title, last_active, timestamp, description)
    VALUES (@ModuleID, @courseID, @title, GETDATE(), GETDATE(), @description)

    PRINT 'Discussion forum created successfully for ModuleID: ' + 
        CAST(@ModuleID AS VARCHAR) + ' and CourseID: ' + CAST(@courseID AS VARCHAR)
END

-- =============================================

GO
CREATE PROCEDURE RemoveBadge (@BadgeID INT)
AS
BEGIN
    DELETE FROM Badge
    WHERE BadgeID = @BadgeID

    PRINT 'Deleted the following badge: ' + CAST(@BadgeID AS VARCHAR)
END

-- =============================================

GO
CREATE PROCEDURE CriteriaDelete (@criteria VARCHAR(50))
AS
BEGIN
    DELETE FROM Quest
    WHERE criteria = @criteria
END

-- =============================================

GO
CREATE PROCEDURE NotificationUpdate (
    @LearnerID INT,
    @NotificationID INT,
    @ReadStatus BIT
)
AS
BEGIN
    IF @ReadStatus = 1
    BEGIN
        UPDATE Notification
        SET urgency_level = 'read'
        WHERE ID = @NotificationID
        AND EXISTS (
            SELECT 1
            FROM ReceivedNotification
            WHERE LearnerID = @LearnerID AND NotificationID = @NotificationID
        );

        PRINT 'notfication is read';
    END
    ELSE
    BEGIN
        DELETE FROM ReceivedNotification
        WHERE LearnerID = @LearnerID AND NotificationID = @NotificationID;

        PRINT 'notfication deleted';
    END
END

exec NotificationUpdate 2 ,2 ,1

-- =============================================

GO
CREATE PROCEDURE EmotionalTrendAnalysis (
    @CourseID INT,
    @ModuleID INT,
    @TimePeriod DATETIME
)
AS
BEGIN
    SELECT ef.emotional_state, l.LearnerID
    FROM Emotional_feedback ef
    INNER JOIN Learner l ON l.LearnerID = ef.LearnerID
    INNER JOIN Course_enrollment ce ON ce.LearnerID = l.LearnerID
    INNER JOIN Modules m ON ce.CourseID = m.CourseID
    INNER JOIN Course c ON m.CourseID = c.CourseID
    WHERE c.CourseID = @CourseID
        AND m.ModuleID = @ModuleID
        AND ce.enrollment_date <= @TimePeriod
        AND ce.completion_date >= @TimePeriod
END

-- =============================================

GO
CREATE PROCEDURE ProfileUpdate (
    @LearnerID INT,
    @ProfileID INT,
    @PreferedContentType VARCHAR(50),
    @emotional_state VARCHAR(50),
    @PersonalityType VARCHAR(50)
)
AS
BEGIN
    UPDATE PersonalizationProfiles
    SET 
        Prefered_content_type = @PreferedContentType,
        emotional_state = @emotional_state,
        personality_type = @PersonalityType
    WHERE LearnerID = @LearnerID AND ProfileID = @ProfileID
END

-- =============================================

GO
CREATE PROCEDURE TotalPoints (
    @LearnerID INT,
    @RewardType VARCHAR(50)
)
AS
BEGIN
    SELECT SUM(r.value)
    FROM Reward r
    INNER JOIN QuestReward qr ON r.RewardID = qr.RewardID
    WHERE qr.LearnerID = @LearnerID AND r.type = @RewardType
END

-- =============================================

GO
CREATE PROCEDURE EnrolledCourses (@LearnerID INT)
AS
BEGIN
    SELECT 
        c.CourseID,
        c.Title,
        c.learning_objective,
        c.credit_points,
        c.description,
        c.difficulty_level,
        c.pre_requisites,
        ce.status,
        ISNULL(ha.HighestAssessmentGrade, 0) AS HighestAssessmentGrade,
        ha.HighestAssessmentTitle,
        ha.HighestAssessmentId
    FROM Course_enrollment ce
    INNER JOIN Learner l ON l.LearnerID = ce.LearnerID
    INNER JOIN Course c ON c.CourseID = ce.CourseID
    LEFT JOIN (
        SELECT 
            ranked.CourseID,
            ranked.total_marks AS HighestAssessmentGrade,
            ranked.Title AS HighestAssessmentTitle,
            ranked.ID AS HighestAssessmentId
        FROM (
            SELECT 
                a.CourseID,
                a.total_marks,
                a.Title,
                a.ID,
                ROW_NUMBER() OVER (PARTITION BY a.CourseID ORDER BY a.total_marks DESC) AS Rank
            FROM Assessments a
        ) ranked
        WHERE ranked.Rank = 1
    ) ha ON ha.CourseID = c.CourseID
    WHERE l.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE Prerequisites (
    @LearnerID INT,
    @CourseID INT,
    @StatusMessage VARCHAR(100) OUTPUT
)
AS
BEGIN
    DECLARE @Prerequisites VARCHAR(100)

    SELECT @Prerequisites = pre_requisites
    FROM Course
    WHERE CourseID = @CourseID

    IF @Prerequisites IS NULL OR @Prerequisites = ''
    BEGIN
        SET @StatusMessage = 'No prerequisites required for this course.'
        RETURN
    END

    IF NOT EXISTS (
        SELECT 1
        FROM Course_enrollment ce
        WHERE ce.LearnerID = @LearnerID
            AND ce.CourseID IN (SELECT value FROM STRING_SPLIT(@Prerequisites, ','))
            AND ce.status = 'Completed'
    )
    BEGIN
        SET @StatusMessage = 'Prerequisites are not yet completed.'
    END
    ELSE
    BEGIN
        SET @StatusMessage = 'All prerequisites are completed.'
    END
END

-- =============================================

GO
CREATE PROCEDURE Moduletraits (
    @TargetTrait VARCHAR(50),
    @CourseID INT
)
AS
BEGIN
    SELECT m.Title, m.ModuleID
    FROM Modules m
    INNER JOIN Target_traits tt ON m.ModuleID = tt.ModuleID AND m.CourseID = tt.CourseID
    WHERE tt.Trait = @TargetTrait AND m.CourseID = @CourseID
END

-- =============================================

GO
CREATE PROCEDURE LeaderboardRank (
    @LeaderboardID INT,
    @learnerID INT
)
AS
BEGIN
    SELECT r.BoardID, r.CourseID, r.LearnerID, r.rank, r.total_points
    FROM Ranking r
    WHERE r.BoardID = @LeaderboardID AND r.LearnerID = @learnerID
    ORDER BY r.rank
END

-- =============================================

GO
CREATE PROCEDURE ViewMyDeviceCharge (
    @ActivityID INT,
    @LearnerID INT,
    @timestamp TIME,
    @emotionalstate VARCHAR(50)
)
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Learning_activities
        WHERE ActivityID = @ActivityID
    )
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Learner
            WHERE LearnerID = @LearnerID
        )
        BEGIN
            INSERT INTO Emotional_feedback (FeedbackID, LearnerID, timestamp, emotional_state)
            VALUES (
                (SELECT ISNULL(MAX(FeedbackID), 0) + 1 FROM Emotional_feedback),
                @LearnerID,
                GETDATE(),
                @emotionalstate
            )

            PRINT 'Emotional feedback submitted successfully.'
        END
        ELSE
        BEGIN
            PRINT 'Error: Learner does not exist.'
        END
    END
    ELSE
    BEGIN
        PRINT 'Error: Activity does not exist.'
    END
END

-- =============================================

GO
CREATE PROCEDURE JoinQuest (
    @LearnerID INT,
    @QuestID INT
)
AS
BEGIN
    DECLARE @MaxParticipants INT
    DECLARE @CurrentParticipants INT

    SELECT @MaxParticipants = max_num_participants
    FROM Collaborative
    WHERE QuestID = @QuestID

    IF @MaxParticipants IS NULL
    BEGIN
        PRINT 'Error: Quest does not exist.'
        RETURN
    END

    SELECT @CurrentParticipants = COUNT(*)
    FROM QuestReward
    WHERE QuestID = @QuestID

    IF @CurrentParticipants < @MaxParticipants
    BEGIN
        INSERT INTO QuestReward (RewardID, QuestID, LearnerID, Time_earned)
        VALUES (
            (SELECT ISNULL(MAX(RewardID), 0) + 1 FROM QuestReward),
            @QuestID,
            @LearnerID,
            GETDATE()
        )
        PRINT 'Approval: You have successfully joined the quest.'
    END
    ELSE
    BEGIN
        PRINT 'Rejection: No space available in the quest.'
    END
END

-- =============================================

GO
CREATE PROC SkillsProfeciency (@learnerId INT)
AS
BEGIN
    SELECT skill_name, proficiency_level
    FROM SkillProgression
    WHERE LearnerID = @learnerId
END

-- =============================================

GO
CREATE PROC Viewscore (@LearnerID INT, @AssessmentID INT, @score INT OUTPUT)
AS
BEGIN
    SELECT @score = ScoredPoints
    FROM takesassesment
    WHERE learner_id = @LearnerID AND @AssessmentID = assesment_id
END

-- =============================================

GO
CREATE PROC AssessmentsList (@courseID INT, @ModuleID INT, @LearnerID INT)
AS
BEGIN
    SELECT a.title, t.ScoredPoints
    FROM takesassesment t
    INNER JOIN Assessments a ON t.assesment_id = a.ID
    INNER JOIN Learner l ON l.LearnerID = t.learner_id
    WHERE a.ModuleID = @ModuleID AND a.CourseID = @courseID AND t.learner_id = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE Courseregister (@LearnerID INT, @CourseID INT)
AS
BEGIN
    DECLARE @preq INT
    DECLARE @preqmet INT

    SELECT @preq = COUNT(*)
    FROM Prerequisites p
    WHERE p.course_id = @CourseID

    SELECT @preqmet = COUNT(*)
    FROM Course_enrollment ce
    INNER JOIN Prerequisites p ON ce.CourseID = p.prereq
    WHERE p.course_id = @CourseID
        AND ce.LearnerID = @LearnerID
        AND ce.status = 'Completed'

    IF @preq = 0
    BEGIN
        INSERT INTO Course_enrollment (CourseID, LearnerID, enrollment_date, status)
        VALUES (@CourseID, @LearnerID, GETDATE(), 'Enrolled')
        SELECT 'Registration approved' AS Message
    END
    ELSE IF @preqmet = @preq
    BEGIN
        INSERT INTO Course_enrollment (CourseID, LearnerID, enrollment_date, status)
        VALUES (@CourseID, @LearnerID, GETDATE(), 'Enrolled')
        SELECT 'Registration approved' AS Message
    END
    ELSE
    BEGIN
        SELECT 'Registration Failed, You did not complete all prerequisites of this course' AS Message
    END
END

-- =============================================

GO
CREATE PROC Post (@LearnerID INT, @DiscussionID INT, @Post VARCHAR(MAX))
AS
BEGIN
    INSERT INTO LearnerDiscussion (ForumID, LearnerID, Post, time)
    VALUES (@DiscussionID, @LearnerID, @Post, GETDATE())
END

-- =============================================

GO
CREATE PROC AddGoal (@LearnerID INT, @GoalID INT)
AS
BEGIN
    INSERT INTO LearnersGoals (GoalID, LearnerID)
    VALUES (@GoalID, @LearnerID)
END

-- =============================================

GO
CREATE PROC CurrentPath (@LearnerID INT)
AS
BEGIN
    SELECT *
    FROM Learning_path
    WHERE LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROC QuestMembers (@LearnerID INT)
AS
BEGIN
    SELECT l.first_name, l.last_name, c.QuestID
    FROM LearnersCollaboration lc
    INNER JOIN Collaborative c ON lc.QuestID = c.QuestID
    INNER JOIN LearnersCollaboration other ON lc.QuestID = other.QuestID
    INNER JOIN Learner l ON other.LearnerID = l.LearnerID
    WHERE lc.LearnerID = @LearnerID AND c.deadline > GETDATE()
END

-- =============================================

GO
CREATE PROC QuestProgress (@LearnerID INT)
AS
BEGIN
    SELECT 
        Q.QuestID,
        Q.title AS QuestTitle,
        C.deadline AS deadline,
        LC.completion_status AS QuestCompletionStatus
    FROM Collaborative C
    INNER JOIN LearnersCollaboration LC ON C.QuestID = LC.QuestID
    INNER JOIN Quest Q ON C.QuestID = Q.QuestID
    WHERE LC.LearnerID = @LearnerID AND C.deadline > GETDATE()

    SELECT 
        B.BadgeID,
        B.title AS BadgeTitle,
        A.date_earned AS DateEarned,
        B.criteria AS BadgeCriteria
    FROM Achievement A
    INNER JOIN Badge B ON A.BadgeID = B.BadgeID
    WHERE A.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE GoalReminder (@LearnerID INT)
AS
BEGIN
    DECLARE @remdays INT
    DECLARE @goaldesc VARCHAR(MAX)

    SELECT 
        @remdays = DATEDIFF(DAY, GETDATE(), deadline),
        @goaldesc = g.description
    FROM Learner l
    INNER JOIN LearnersGoals lg ON l.LearnerID = lg.LearnerID
    INNER JOIN Learning_goal g ON lg.GoalID = g.ID
    WHERE l.LearnerID = @LearnerID

    IF (@remdays < 7)
    BEGIN
        INSERT INTO Notification (timestamp, message, urgency_level)
        VALUES (GETDATE(), 'You are failing behind on ' + @goaldesc, 'high')
    END
END

-- =============================================

GO
CREATE PROCEDURE SkillProgressHistory (
    @LearnerID INT,
    @Skill VARCHAR(50)
)
AS
BEGIN
    SELECT 
        SP.timestamp AS ProgressDate,
        SP.proficiency_level AS SkillLevel
    FROM SkillProgression SP
    INNER JOIN Skills S ON SP.LearnerID = S.LearnerID AND SP.skill_name = S.skill
    WHERE SP.LearnerID = @LearnerID AND SP.skill_name = @Skill
    ORDER BY SP.timestamp ASC
END

-- =============================================

GO
CREATE PROCEDURE AssessmentAnalysis (@LearnerID INT)
AS
BEGIN
    SELECT 
        a.ID,
        a.title,
        a.description,
        a.CourseID,
        a.ModuleID,
        a.title AS Assessment,
        a.type,
        t.ScoredPoints AS grade,
        a.total_marks,
        a.passing_marks,
        a.criteria,
        a.weightage
    FROM takesassesment t
    INNER JOIN Assessments a ON t.assesment_id = a.ID
    WHERE t.learner_id = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE LeaderboardFilter (@LearnerID INT)
AS
BEGIN
    SELECT 
        r.LearnerID,
        r.BoardID,
        r.CourseID,
        r.total_points,
        r.rank
    FROM Leaderboard l
    INNER JOIN Ranking r ON l.BoardID = r.BoardID
    INNER JOIN Course c ON r.CourseID = c.CourseID
    WHERE LearnerID = @LearnerID
    ORDER BY rank DESC
END

-- =============================================

GO
CREATE PROCEDURE SkillLearners (@Skillname VARCHAR(50))
AS
BEGIN
    SELECT 
        s.skill,
        l.LearnerID,
        l.first_name,
        l.last_name
    FROM Skills s
    JOIN Learner l ON s.LearnerID = l.LearnerID
    WHERE s.skill = @Skillname
END

-- =============================================

GO
CREATE PROCEDURE NewActivity (
    @CourseID INT,
    @ModuleID INT,
    @activitytype VARCHAR(50),
    @instructiondetails VARCHAR(MAX),
    @maxpoints INT
)
AS
BEGIN
    INSERT INTO Learning_activities (
        CourseID,
        ModuleID,
        activity_type,
        instruction_details,
        Max_points
    )
    VALUES (
        @CourseID,
        @ModuleID,
        @activitytype,
        @instructiondetails,
        @maxpoints
    )
END

-- =============================================

GO
CREATE PROCEDURE NewAchievement (
    @LearnerID INT,
    @BadgeID INT,
    @description VARCHAR(MAX),
    @date_earned DATE,
    @type VARCHAR(50)
)
AS
BEGIN
    INSERT INTO Achievement (
        LearnerID,
        BadgeID,
        description,
        date_earned,
        type
    )
    VALUES (
        @LearnerID,
        @BadgeID,
        @description,
        @date_earned,
        @type
    )

    PRINT 'Achievement awarded successfully!'
END

-- =============================================

GO
CREATE PROCEDURE LearnerBadge (@BadgeID INT)
AS
BEGIN
    SELECT 
        l.LearnerID,
        l.first_name,
        l.last_name,
        a.date_earned,
        b.title AS BadgeTitle
    FROM Achievement a
    JOIN Learner l ON a.LearnerID = l.LearnerID
    JOIN Badge b ON a.BadgeID = b.BadgeID
    WHERE a.BadgeID = @BadgeID
    ORDER BY l.last_name, l.first_name
END

-- =============================================

GO
CREATE PROCEDURE NewPath (
    @LearnerID INT,
    @ProfileID INT,
    @completion_status VARCHAR(50),
    @custom_content VARCHAR(MAX),
    @adaptiverules VARCHAR(MAX)
)
AS
BEGIN
    INSERT INTO Learning_path (
        LearnerID,
        ProfileID,
        completion_status,
        custom_content,
        adaptive_rules
    )
    VALUES (
        @LearnerID,
        @ProfileID,
        @completion_status,
        @custom_content,
        @adaptiverules
    )

    PRINT 'Learning path added successfully!'
END

EXEC NewPath 
    @LearnerID = 1, 
    @ProfileID = 101, 
    @completion_status = 'In Progress', 
    @custom_content = 'Extra tutorials on Python basics.', 
    @adaptiverules = 'Adaptive learning based on quiz scores.';

-- =============================================

GO
CREATE PROCEDURE TakenCourses (@LearnerID INT)
AS
BEGIN
    SELECT 
        c.CourseID,
        c.Title,
        c.learning_objective,
        ce.status
    FROM Course c
    JOIN Course_enrollment ce ON c.CourseID = ce.CourseID
    WHERE ce.LearnerID = @LearnerID
END

-- =============================================

GO
CREATE PROCEDURE CollaborativeQuest (
    @difficulty_level VARCHAR(50),
    @criteria VARCHAR(50),
    @description VARCHAR(50),
    @title VARCHAR(50),
    @Maxnumparticipants INT,
    @deadline DATETIME
)
AS
BEGIN
    INSERT INTO Quest (difficulty_level, criteria, description, title)
    VALUES (@difficulty_level, @criteria, @description, @title)

    DECLARE @QuestID INT = SCOPE_IDENTITY()

    INSERT INTO Collaborative (QuestID, deadline, max_num_participants)
    VALUES (@QuestID, @deadline, @Maxnumparticipants)
END

-- =============================================

GO
CREATE PROCEDURE DeadlineUpdate (
    @QuestID INT,
    @deadline DATETIME
)
AS
BEGIN
    UPDATE Collaborative
    SET deadline = @deadline
    WHERE QuestID = @QuestID

    PRINT 'Quest deadline updated successfully!'
END

-- =============================================

GO
CREATE PROCEDURE GradeUpdate (
    @LearnerID INT,
    @AssessmentID INT,
    @points INT
)
AS
BEGIN
    UPDATE takesassesment
    SET ScoredPoints = @points
    WHERE learner_id = @LearnerID AND assesment_id = @AssessmentID
END

-- =============================================

GO
CREATE PROCEDURE AssessmentNot (
    @NotificationID INT,
    @timestamp DATETIME,
    @message VARCHAR(MAX),
    @urgencylevel VARCHAR(50),
    @LearnerID INT
)
AS
BEGIN
    SET IDENTITY_INSERT Notification ON

    INSERT INTO Notification (ID, timestamp, message, urgency_level)
    VALUES (@NotificationID, @timestamp, @message, @urgencylevel)

    SET IDENTITY_INSERT Notification OFF

    INSERT INTO ReceivedNotification (NotificationID, LearnerID)
    VALUES (@NotificationID, @LearnerID)

    PRINT 'Sent notification: ' + CAST(@NotificationID AS VARCHAR) + 
          ' to learner: ' + CAST(@LearnerID AS VARCHAR)
END

-- =============================================

GO
CREATE PROCEDURE NewGoal (
    @GoalID INT,
    @status VARCHAR(MAX),
    @deadline DATETIME,
    @description VARCHAR(MAX)
)
AS
BEGIN
    SET IDENTITY_INSERT Learning_goal ON

    INSERT INTO Learning_goal (ID, status, deadline, description)
    VALUES (@GoalID, @status, @deadline, @description)

    SET IDENTITY_INSERT Learning_goal OFF
END

-- =============================================

GO
CREATE PROCEDURE LearnersCourses (
    @CourseID INT,
    @InstructorID INT
)
AS
BEGIN
    SELECT 
        L.LearnerID,
        L.first_name,
        L.last_name,
        L.gender,
        L.birth_date,
        L.country,
        L.cultural_background,
        C.Title AS CourseTitle
    FROM Course_enrollment CE
    INNER JOIN Learner L ON CE.LearnerID = L.LearnerID
    INNER JOIN Course C ON CE.CourseID = C.CourseID
    INNER JOIN Teaches T ON T.CourseID = C.CourseID
    WHERE T.InstructorID = @InstructorID
      AND (@CourseID IS NULL OR C.CourseID = @CourseID)
END

-- =============================================

GO
CREATE PROCEDURE LastActive (@ForumID INT, @lastactive DATETIME OUTPUT)
AS
BEGIN
    SELECT last_active
    FROM Discussion_forum
    WHERE forumID = @ForumID
END

-- =============================================

GO
CREATE PROCEDURE CommonEmotionalState (@state VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT TOP 1 emotional_state
    FROM Emotional_feedback
    GROUP BY emotional_state
    ORDER BY COUNT(*) DESC
END

-- =============================================

GO
CREATE PROCEDURE ModuleDifficulty (@courseID INT)
AS
BEGIN
    SELECT *
    FROM Modules
    WHERE CourseID = @courseID
    ORDER BY difficulty
END

-- =============================================

GO
CREATE PROCEDURE Profeciencylevel (@LearnerID INT, @skill VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT TOP 1 @skill = skill_name
    FROM SkillProgression
    WHERE LearnerID = @LearnerID
    ORDER BY CASE
        WHEN proficiency_level = 'Expert' THEN 1
        WHEN proficiency_level = 'Advanced' THEN 2
        WHEN proficiency_level = 'Intermediate' THEN 3
        WHEN proficiency_level = 'Beginner' THEN 4
        ELSE 5
    END
END

-- =============================================

GO
CREATE PROCEDURE ProfeciencyUpdate (
    @Skill VARCHAR(50),
    @LearnerId INT,
    @Level VARCHAR(50)
)
AS
BEGIN
    UPDATE SkillProgression
    SET proficiency_level = @Level
    WHERE skill_name = @Skill AND LearnerId = @LearnerId
END

-- =============================================

GO
CREATE PROCEDURE LeastBadge (@LearnerID INT OUTPUT)
AS
BEGIN
    SELECT TOP 1 LearnerID
    FROM Achievement
    GROUP BY LearnerID
    ORDER BY COUNT(BadgeID) ASC
END

-- =============================================

GO
CREATE PROCEDURE PreferedType (@type VARCHAR(50) OUTPUT)
AS
BEGIN
    SELECT TOP 1 preference
    FROM LearningPreference
    GROUP BY preference
    ORDER BY COUNT(LearnerID) DESC
END

-- =============================================

GO
CREATE PROCEDURE AssessmentAnalytics (
    @CourseID INT,
    @ModuleID INT
)
AS
BEGIN
    SELECT 
        a.ID AS AssessmentID,
        a.title AS AssessmentTitle,
        a.total_marks AS TotalMarks,
        a.passing_marks AS PassingMarks,
        AVG(t.ScoredPoints) AS AverageScore
    FROM Assessments a
    INNER JOIN takesassesment t ON a.ID = t.assesment_id
    WHERE a.CourseID = @CourseID AND a.ModuleID = @ModuleID
    GROUP BY a.ID, a.title, a.total_marks, a.passing_marks
    ORDER BY a.ID
END

-- =============================================

GO
CREATE PROCEDURE EmotionalTrendAnalysisIns (
    @CourseID INT,
    @ModuleID INT,
    @TimePeriod DATETIME
)
AS
BEGIN
    SELECT 
        EF.timestamp AS FeedbackTime,
        EF.emotional_state,
        L.first_name + ' ' + L.last_name AS LearnerName,
        M.Title AS ModuleTitle,
        C.Title AS CourseTitle
    FROM Emotional_feedback EF
    INNER JOIN Learner L ON EF.LearnerID = L.LearnerID
    INNER JOIN Course_enrollment CE ON L.LearnerID = CE.LearnerID AND CE.CourseID = @CourseID
    INNER JOIN Modules M ON M.CourseID = @CourseID AND M.ModuleID = @ModuleID
    INNER JOIN Course C ON M.CourseID = C.CourseID
    WHERE EF.timestamp >= @TimePeriod
END