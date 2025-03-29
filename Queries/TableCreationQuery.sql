DROP DATABASE GamifiedPlatform
CREATE DATABASE GamifiedPlatform

USE GamifiedPlatform

ALTER TABLE Assessments
ADD Grade INT NULL; 

Alter Table ReceivedNotification
ADD adminID int

Alter Table ReceivedNotification
Add constraint FK_ReceivedNotification_Admin FOREIGN KEY(adminID) references Admin(AdminID)


ALTER TABLE Learner
Add ProfilePicturePath varchar(100)

ALTER TABLE Instructor
Add ProfilePicturePath varchar(100)

ALTER TABLE Course
Add Status varchar(20)

ALTER TABLE Course
add HighestAssessmentId int

ALTER TABLE Course
add HighestAssessmentTitle varchar(50)

ALTER TABLE Course
add HighestAssessmentGrade int


ALTER TABLE Quest
add deadline datetime  

CREATE TABLE Users(
    UserID INT primary Key Identity,
    Name NVARCHAR(100),
    Email NVARCHAR(100),
    Password varchar(50),
    Type varchar(50)
);

CREATE TABLE Admin (
    AdminID INT PRIMARY KEY IDENTITY,
    UserID INT NOT NULL,
    Name VARCHAR(50),
    gender CHAR(1),
    birth_date DATE,
    country VARCHAR(50),
    email VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Learner (
    LearnerID INT PRIMARY KEY identity,
    UserID INT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    birth_date DATE,
    country VARCHAR(50),
    email VARCHAR(50),
    cultural_background VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Skills (
    LearnerID INT,
    skill VARCHAR(50),
    PRIMARY KEY (LearnerID, skill),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LearningPreference (
    LearnerID INT,
    preference VARCHAR(50),
    PRIMARY KEY (LearnerID, preference),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PersonalizationProfiles (
    LearnerID INT,
    ProfileID INT,
    Prefered_content_type VARCHAR(50),
    emotional_state VARCHAR(50),
    personality_type VARCHAR(50),
    PRIMARY KEY (LearnerID, ProfileID),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HealthCondition (
    LearnerID INT,
    ProfileID INT,
    condition VARCHAR(50),
    PRIMARY KEY (LearnerID, ProfileID, condition),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY identity,
    Title VARCHAR(50),
    learning_objective VARCHAR(50),
    credit_points INT,
    difficulty_level VARCHAR(50),
    pre_requisites VARCHAR(50),
    description VARCHAR(50)
);

CREATE TABLE Prerequisites (
    course_id INT,
    prereq INT,
    PRIMARY KEY (course_id, prereq),
    FOREIGN KEY (course_id) REFERENCES Course(CourseID),
    FOREIGN KEY (prereq) REFERENCES Course(CourseID)
);

CREATE TABLE Modules (
    ModuleID INT identity ,
    CourseID INT,
    Title VARCHAR(50),
    difficulty VARCHAR(50),
    contentURL VARCHAR(50),
    PRIMARY KEY(ModuleID,CourseID),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Target_traits (
    ModuleID INT,
    CourseID INT,
    Trait VARCHAR(50),
    PRIMARY KEY (ModuleID, CourseID, Trait),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ModuleContent (
    ModuleID INT,
    CourseID INT,
    content_type VARCHAR(50),
    PRIMARY KEY (ModuleID, CourseID, content_type),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ContentLibrary (
    ID INT PRIMARY KEY identity,
    ModuleID INT,
    CourseID INT,
    Title VARCHAR(50),
    description VARCHAR(50),
    metadata VARCHAR(50),
    type VARCHAR(50),
    content_URL VARCHAR(50),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Assessments (
    ID INT PRIMARY KEY identity,
    ModuleID INT,
    CourseID INT,
    type VARCHAR(50),
    total_marks INT,
    passing_marks INT,
    criteria VARCHAR(50),
    weightage INT,
    description VARCHAR(50),
    title VARCHAR(50),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Learning_activities (
    ActivityID INT PRIMARY KEY identity,
    ModuleID INT,
    CourseID INT,
    activity_type VARCHAR(50),
    instruction_details VARCHAR(100),
    Max_points INT,
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Interaction_log (
    LogID INT PRIMARY KEY identity,
    activity_ID INT,
    LearnerID INT,
    Duration TIME,
    Timestamp DATETIME ,
    action_type VARCHAR(50),
    FOREIGN KEY (activity_ID) REFERENCES Learning_activities(ActivityID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Emotional_feedback (
    FeedbackID INT PRIMARY KEY identity,
    LearnerID INT,
    timestamp DATETIME,
    emotional_state VARCHAR(50),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Learning_path (
    pathID INT PRIMARY KEY identity,
    LearnerID INT,
    ProfileID INT,
    completion_status VARCHAR(50),
    custom_content VARCHAR(50),
    adaptive_rules VARCHAR(50),
    FOREIGN KEY (LearnerID, ProfileID) REFERENCES PersonalizationProfiles(LearnerID, ProfileID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Instructor (
    InstructorID INT PRIMARY KEY IDENTITY,
    UserID INT NOT NULL, 
    name VARCHAR(50),
    latest_qualification VARCHAR(50),
    expertise_area VARCHAR(50),
    email VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

CREATE TABLE Pathreview (
    InstructorID INT,
    PathID INT,
    feedback VARCHAR(50),
    PRIMARY KEY (InstructorID, PathID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PathID) REFERENCES Learning_path(pathID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Emotionalfeedback_review (
    FeedbackID INT,
    InstructorID INT,
    feedback VARCHAR(100),
    PRIMARY KEY (FeedbackID, InstructorID),
    FOREIGN KEY (FeedbackID) REFERENCES Emotional_feedback(FeedbackID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Course_enrollment (
    EnrollmentID INT PRIMARY KEY identity,
    CourseID INT,
    LearnerID INT,
    completion_date DATETIME,
    enrollment_date DATETIME,
    status VARCHAR(50),
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Teaches (
    InstructorID INT,
    CourseID INT,
    PRIMARY KEY (InstructorID, CourseID),
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Leaderboard (
    BoardID INT PRIMARY KEY identity,
    season VARCHAR(50)
);

CREATE TABLE Ranking (
    BoardID INT,
    LearnerID INT,
    CourseID INT,
    rank INT,
    total_points INT,
    PRIMARY KEY (BoardID, LearnerID, CourseID),
    FOREIGN KEY (BoardID) REFERENCES Leaderboard(BoardID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Learning_goal (
    ID INT PRIMARY KEY identity,
    status VARCHAR(50),
    deadline DATETIME,
    description VARCHAR(50)
);

CREATE TABLE LearnersGoals (
    GoalID INT,
    LearnerID INT,
    PRIMARY KEY (GoalID, LearnerID),
    FOREIGN KEY (GoalID) REFERENCES Learning_goal(ID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Survey (
    ID INT PRIMARY KEY identity,
    Title VARCHAR(50)
);

CREATE TABLE SurveyQuestions (
    SurveyID INT,
    Question VARCHAR(100),
    PRIMARY KEY (SurveyID, Question),
    FOREIGN KEY (SurveyID) REFERENCES Survey(ID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FilledSurvey (
    SurveyID INT,
    Question VARCHAR(100),
    LearnerID INT,
    Answer VARCHAR(50),
    PRIMARY KEY (SurveyID, Question, LearnerID),
    FOREIGN KEY (SurveyID, Question) REFERENCES SurveyQuestions(SurveyID, Question)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE 
);

CREATE TABLE Notification (
    ID INT PRIMARY KEY identity,
    timestamp DATETIME,
    message VARCHAR(100),
    urgency_level VARCHAR(50)
);

CREATE TABLE ReceivedNotification (
    NotificationID INT,
    LearnerID INT,
    PRIMARY KEY (NotificationID, LearnerID),
    FOREIGN KEY (NotificationID) REFERENCES Notification(ID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Badge (
    BadgeID INT PRIMARY KEY identity,
    title VARCHAR(100),
    description VARCHAR(100),
    criteria VARCHAR(100),
    points INT
);

CREATE TABLE SkillProgression (
    ID INT PRIMARY KEY identity,
    proficiency_level VARCHAR(50),
    LearnerID INT,
    skill_name VARCHAR(50),
    timestamp DATETIME,
    FOREIGN KEY (LearnerID, skill_name) REFERENCES Skills(LearnerID, skill)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Achievement (
    AchievementID INT PRIMARY KEY identity,
    LearnerID INT,
    BadgeID INT,
    description VARCHAR(100),
    date_earned DATETIME,
    type VARCHAR(50),
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID)ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BadgeID) REFERENCES Badge(BadgeID)ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reward (
    RewardID INT PRIMARY KEY identity,
    value DECIMAL(10, 2),
    description VARCHAR(100),
    type VARCHAR(50)
);

CREATE TABLE Quest (
    QuestID INT PRIMARY KEY identity,
    difficulty_level VARCHAR(50),
    criteria VARCHAR(100),
    description VARCHAR(100),
    title VARCHAR(50)
);

CREATE TABLE Skill_Mastery (
    QuestID INT,
    skill VARCHAR(50),
    PRIMARY KEY (QuestID, skill),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)ON DELETE CASCADE ON UPDATE CASCADE
);

-- 37
CREATE TABLE Collaborative (
    QuestID INT,
    deadline DATETIME,
    max_num_participants INT,
    PRIMARY KEY (QuestID),
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID)ON DELETE CASCADE ON UPDATE CASCADE
);

create table LearnersCollaboration(
    LearnerID int,
    QuestID int,
    completion_status nvarchar(MAX),
    Primary key(LearnerID,QuestID),
    FOREIGN KEY(LearnerID) references Learner(LearnerID) ,
    FOREIGN KEY(QuestID) references Collaborative(QuestID)
);

CREATE TABLE LearnerMastery(
    LearnerID INT,
    QuestID INT,
    skill VARCHAR(50),
    completion_status NVARCHAR(MAX),
    PRIMARY KEY(LearnerID,QuestID,skill),
    FOREIGN KEY(LearnerID) references Learner(LearnerID) ,
    FOREIGN KEY(QuestID,skill) references Skill_Mastery(QuestID,skill)
);

CREATE TABLE Discussion_forum (
    forumID INT PRIMARY KEY identity,
    ModuleID INT,
    CourseID INT,
    title VARCHAR(50),
    last_active DATETIME,
    timestamp DATETIME,
    description VARCHAR(100),
    FOREIGN KEY (ModuleID, CourseID) REFERENCES Modules(ModuleID, CourseID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE InstructorDiscussion(
    ForumID int,
    InstructorID int,
    Post VARCHAR(100),
    time DATETIME,
    PRIMARY KEY (ForumID, InstructorID),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LearnerDiscussion (
    ForumID INT,
    LearnerID INT,
    Post VARCHAR(100),
    time DATETIME,
    PRIMARY KEY (ForumID, LearnerID),
    FOREIGN KEY (ForumID) REFERENCES Discussion_forum(forumID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE QuestReward (
    RewardID INT,
    QuestID INT,
    LearnerID INT,
    Time_earned DATETIME,
    PRIMARY KEY (RewardID, QuestID, LearnerID),
    FOREIGN KEY (RewardID) REFERENCES Reward(RewardID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (QuestID) REFERENCES Quest(QuestID) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (LearnerID) REFERENCES Learner(LearnerID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE takesassesment(
    learner_id INT,
    assesment_id INT,
    ScoredPoints INT,
    PRIMARY KEY(learner_id,assesment_id),
    FOREIGN KEY(learner_id) REFERENCES Learner ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(assesment_id) REFERENCES Assessments ON DELETE CASCADE ON UPDATE CASCADE
);
