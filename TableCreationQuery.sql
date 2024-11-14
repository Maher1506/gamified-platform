--CREATE DATABASE GamifiedPlatform

--use GamifiedPlatform

--USE master;  -- Switch to the master database
--DROP DATABASE GamifiedPlatform;

 --1
CREATE TABLE Learner (
    LearnerID INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    birth_date DATE,
    country VARCHAR(50),
    cultural_background VARCHAR(50)
);

-- 2
CREATE TABLE Skills (
    LearnerID INT,
    skill VARCHAR(50),
    PRIMARY KEY (LearnerID, skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- 3
CREATE TABLE LearningPreference (
    LearnerID INT,
    preference VARCHAR(50),
    PRIMARY KEY (LearnerID, preference),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--4
CREATE TABLE PersonalizationProfiles (
    LearnerID INT,
    ProfileID INT,
    Prefered_content_type VARCHAR(50),
    emotional_state VARCHAR(50),
    personality_type VARCHAR(50),
    PRIMARY KEY (LearnerID, ProfileID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--5
CREATE TABLE HealthCondition (
    LearnerID INT,
    ProfileID INT,
    condition VARCHAR(50),
    PRIMARY KEY (LearnerID, ProfileID, condition),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)
);

--6
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    Title VARCHAR(50),
    learning_objective VARCHAR(50),
    credit_points INT,
    difficulty_level VARCHAR(50),
    pre_requisites VARCHAR(50),
    description VARCHAR(50)
);

-- 7
CREATE TABLE Modules (
    ModuleID INT ,
    CourseID INT,
    Title VARCHAR(50),
    difficulty VARCHAR(50),
    contentURL VARCHAR(50),
    PRIMARY KEY(ModuleID,CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- 8
CREATE TABLE Target_traits (
    ModuleID INT,
    CourseID INT,
    Trait VARCHAR(50),
    PRIMARY KEY (ModuleID, CourseID, Trait),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

--9
CREATE TABLE ModuleContent (
    ModuleID INT,
    CourseID INT,
    content_type VARCHAR(50),
    PRIMARY KEY (ModuleID, CourseID, content_type),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

--10
CREATE TABLE ContentLibrary (
    ID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    Title VARCHAR(50),
    description VARCHAR(50),
    metadata VARCHAR(50),
    type VARCHAR(50),
    content_URL VARCHAR(50),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

--11
CREATE TABLE Assessments (
    ID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    type VARCHAR(50),
    total_marks INT,
    passing_marks INT,
    criteria VARCHAR(50),
    weightage INT,
    description VARCHAR(50),
    title VARCHAR(50),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- 12
CREATE TABLE Interaction_log (
    LogID INT PRIMARY KEY,
    activity_ID INT,
    LearnerID INT,
    Duration TIME,
    Timestamp TIMESTAMP ,
    action_type VARCHAR(50),
    FOREIGN KEY (activity_ID) REFERENCES Learning_activities(ActivityID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- 13
CREATE TABLE Learning_activities (
    ActivityID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    activity_type VARCHAR(50),
    instruction_details VARCHAR(50),
    Max_points INT,
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- 14
CREATE TABLE Emotional_feedback (
    FeedbackID INT PRIMARY KEY,
    LearnerID INT,
    timestamp TIMESTAMP,
    emotional_state VARCHAR(50),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--15
CREATE TABLE Learning_path (
    pathID INT PRIMARY KEY,
    LearnerID INT,
    ProfileID INT,
    completion_status VARCHAR(50),
    custom_content VARCHAR(50),
    adaptive_rules VARCHAR(50),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)
);

-- 16
CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY,
    name VARCHAR(50),
    latest_qualification VARCHAR(50),
    expertise_area VARCHAR(50),
    email VARCHAR(50)
);

-- 17
CREATE TABLE Pathreview (
    InstructorID INT,
    PathID INT,
    feedback VARCHAR(50),
    PRIMARY KEY (InstructorID, PathID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (PathID) REFERENCES Learning_path(pathID)
);

-- `8
CREATE TABLE Emotionalfeedback_review (
    FeedbackID INT,
    InstructorID INT,
    feedback VARCHAR(50),
    PRIMARY KEY (FeedbackID, InstructorID),
    FOREIGN KEY (FeedbackID) REFERENCES Emotional_feedback(FeedbackID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)
);

--19
CREATE TABLE Course_enrollment (
    EnrollmentID INT PRIMARY KEY,
    CourseID INT,
    LearnerID INT,
    completion_date DATETIME,
    enrollment_date DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- 20
CREATE TABLE Teaches (
    InstructorID INT,
    CourseID INT,
    PRIMARY KEY (InstructorID, CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- 21
CREATE TABLE Leaderboard (
    BoardID INT PRIMARY KEY,
    season VARCHAR(50)
);

--22
CREATE TABLE Ranking (
    BoardID INT,
    LearnerID INT,
    CourseID INT,
    rank INT,
    total_points INT,
    PRIMARY KEY (BoardID, LearnerID, CourseID),
    FOREIGN KEY (BoardID) REFERENCES Leaderboard(BoardID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)
);

-- 23
CREATE TABLE Learning_goal (
    ID INT PRIMARY KEY,
    status VARCHAR(50),
    deadline DATETIME,
    description VARCHAR(50)
);

-- 24
CREATE TABLE LearnersGoals (
    GoalID INT,
    LearnerID INT,
    PRIMARY KEY (GoalID, LearnerID),
    FOREIGN KEY (GoalID) REFERENCES Learning_goal(ID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--25
CREATE TABLE Survey (
    ID INT PRIMARY KEY,
    Title VARCHAR(50)
);

-- 26
CREATE TABLE SurveyQuestions (
    SurveyID INT,
    Question VARCHAR(50),
    PRIMARY KEY (SurveyID, Question),
    FOREIGN KEY (SurveyID) REFERENCES Survey(ID)
);

-- 27
CREATE TABLE FilledSurvey (
    SurveyID INT,
    Question VARCHAR(50),
    LearnerID INT,
    Answer VARCHAR(50),
    PRIMARY KEY (SurveyID, Question, LearnerID),
    FOREIGN KEY (SurveyID, Question) REFERENCES SurveyQuestions(SurveyID, Question),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--28
CREATE TABLE Notification (
    ID INT PRIMARY KEY,
    timestamp TIMESTAMP,
    message VARCHAR(50),
    urgency_level VARCHAR(50)
);

-- 29
CREATE TABLE ReceivedNotification (
    NotificationID INT,
    LearnerID INT,
    PRIMARY KEY (NotificationID, LearnerID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

--30
CREATE TABLE Badge (
    BadgeID INT PRIMARY KEY,
    title VARCHAR(50),
    description VARCHAR(50),
    criteria VARCHAR(50),
    points INT
);

-- 31
CREATE TABLE SkillProgression (
    ID INT PRIMARY KEY,
    proficiency_level VARCHAR(50),
    LearnerID INT,
    skill_name VARCHAR(50),
    timestamp TIMESTAMP,
    FOREIGN KEY (LearnerID, skill_name) REFERENCES Skills(LearnerID, skill)
);

-- 32
CREATE TABLE Achievement (
    AchievementID INT PRIMARY KEY,
    LearnerID INT,
    BadgeID INT,
    description VARCHAR(50),
    date_earned DATETIME,
    type VARCHAR(50),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID),
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID)
);

--33
CREATE TABLE Reward (
    RewardID INT PRIMARY KEY,
    value DECIMAL(10, 2),
    description VARCHAR(50),
    type VARCHAR(50)
);

-- 34
CREATE TABLE Quest (
    QuestID INT PRIMARY KEY,
    difficulty_level VARCHAR(50),
    criteria VARCHAR(50),
    description VARCHAR(50),
    title VARCHAR(50)
);

-- 35
CREATE TABLE Skill_Mastery (
    QuestID INT,
    skill VARCHAR(50),
    PRIMARY KEY (QuestID, skill),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)
);

-- 36
CREATE TABLE Collaborative (
    QuestID INT,
    deadline DATETIME,
    max_num_participants INT,
    PRIMARY KEY (QuestID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)
);

--37
CREATE TABLE Discussion_forum (
    forumID INT PRIMARY KEY,
    ModuleID INT,
    CourseID INT,
    title VARCHAR(50),
    last_active DATETIME,
    timestamp TIMESTAMP,
    description VARCHAR(50),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)
);

-- 38
CREATE TABLE LearnerDiscussion (
    ForumID INT,
    LearnerID INT,
    Post VARCHAR(50),
    time DATETIME,
    PRIMARY KEY (ForumID, LearnerID),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

-- 39
CREATE TABLE QuestReward (
    RewardID INT,
    QuestID INT,
    LearnerID INT,
    Time_earned DATETIME,
    PRIMARY KEY (RewardID, QuestID, LearnerID),
    FOREIGN KEY (RewardID) REFERENCES Reward(RewardID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)
);

