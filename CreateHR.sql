USE master
GO

IF DB_ID('HumanResource') IS NOT NULL
	DROP DATABASE HumanResource	
CREATE DATABASE HumanResource
GO


USE [HumanResource]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jobs](
    [JobID] [int] IDENTITY(1,1) NOT NULL,
	[Position] [varchar](50) NOT NULL,
	[Title] [varchar](50) NOT NULL,
	[Type] [varchar](50) NOT NULL,
	[Medium] [varchar](50) NOT NULL,
	[SlotsRemained] [int] NOT NULL
        CHECK (SlotsRemained >= 0),
    PRIMARY KEY CLUSTERED 
    (
        [JobID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Candidates](
	[CandidateID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
    [LastName] [varchar](50) NOT NULL,
    [Email] [varchar](50) NOT NULL,
    [Phone] [varchar](50) NOT NULL,
    [ShortProfile] [varchar](50) NULL,
    PRIMARY KEY CLUSTERED 
    (
        [CandidateID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Documents](
	[DocumentID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [int] NOT NULL
        REFERENCES Candidates (CandidateID),
    [CVs] [varchar](50) NOT NULL,
    [ReferenceLetter] [varchar](50) NOT NULL,
    [CoverLetter] [varchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [DocumentID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [int] NOT NULL
        REFERENCES Candidates (CandidateID),
    [JobID] [int] NOT NULL
        REFERENCES Jobs (JobID),
    [Status] [varchar](50) NULL DEFAULT 'Under Consideration',    
    PRIMARY KEY CLUSTERED 
    (
        [ApplicationID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departments](
	[DepartmentID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [varchar](50) NOT NULL,
    [ChairmanName] [varchar](50) NOT NULL,
    [Email] [varchar](50) NOT NULL,
    [Phone] [varchar](50) NOT NULL,
    --[Title] [varchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [DepartmentID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interviewers](
	[InterviewerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
    [LastName] [varchar](50) NOT NULL,
    [Email] [varchar](50) NOT NULL,
    [Phone] [varchar](50) NOT NULL,
    [Title] [varchar](50) NOT NULL,
    [DepartmentID] [int] NOT NULL
        REFERENCES dbo.Departments (DepartmentID),
    PRIMARY KEY CLUSTERED 
    (
        [InterviewerID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Interviews](
	[InterviewID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES dbo.Applications (ApplicationID),
    [InterviewerID] [int] NOT NULL
        REFERENCES dbo.Interviewers (InterviewerID),
    [StartTime] [datetime2] NOT NULL,
    [EndTime] [datetime2] NOT NULL,
    [Round] [int] NULL DEFAULT 1,
    [Type] [varchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [InterviewID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tests](
	[TestID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Applications (ApplicationID),
    [StartTime] [datetime2] NOT NULL,
    [EndTime] [datetime2] NOT NULL,
    [Type] [varchar](50) NULL DEFAULT 'Online',
    [Round] [int] NULL DEFAULT 1,
    [Answers] [varchar](50) NOT NULL,
    [Grade] [varchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [TestID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Evaluations](
	[EvaluationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Applications (ApplicationID),
    [Notes] [varchar](50) NOT NULL,
    [Result] [varchar](50) NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [EvaluationID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Reimbursement for candidates
CREATE TABLE [dbo].[Reimbursements](
	[ReimbursementID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Applications (ApplicationID),
    [Request] [varchar](50) NOT NULL,
    [Processed] [varchar](50) NOT NULL,
    [Amount] [int] NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [ReimbursementID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Onboardings](
	[OnboardingID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [int] NOT NULL 
        REFERENCES Candidates (CandidateID),
    [StartDate] [datetime2] NOT NULL,
    PRIMARY KEY CLUSTERED 
    (
        [OnboardingID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Views

CREATE VIEW AllJobs AS
    SELECT *
    FROM Jobs
GO

CREATE VIEW AllCandiates AS
    SELECT *
    FROM Candidates
GO

CREATE VIEW AllOnboardings AS
    SELECT *
    FROM Onboardings
GO

CREATE VIEW AllApplications AS
    SELECT *
    FROM Applications
GO
-- Functions
CREATE FUNCTION fnGetInterviewNo(
    --@CandidateID INT = 0,
    @ApplicationID INT = 0
) RETURNS INT AS
BEGIN
	DECLARE @InterviewNo INT = (
	    SELECT COUNT(*)
		FROM Interviews I 
		WHERE I.ApplicationID=@ApplicationID
	)
	--PRINT('Application ' + CONVERT(VARCHAR, @ApplicationID) + ' has number of test ' + CONVERT(VARCHAR, @InterviewNo))
RETURN @InterviewNo
END
GO

CREATE FUNCTION fnGetTestNo(
    @ApplicationID INT = 0
) RETURNS INT AS
BEGIN
	DECLARE @TestNo INT = (
		SELECT COUNT(*)
		FROM Tests T
		WHERE T.ApplicationID=@ApplicationID
		--JOIN Applications A ON A.ApplicationID = T.ApplicationID
		--WHERE T.ApplicationID = @ApplicationID OR A.CandidateID = @CandidateID
	)
	--SELECT @TestNo AS TestNo;
	--PRINT('Application ' + CONVERT(VARCHAR, @ApplicationID) + ' has number of test ' + CONVERT(VARCHAR, @TestNo))
RETURN @TestNo
END
GO

-- Stored Procedure
CREATE PROC spCreateApplication
    @CandidateID INT = 0,
    @JobID INT = 0,
    @ApplicationID INT = 0 OUTPUT
AS
IF(@CandidateID=0 OR @JobID=0)
    PRINT('ERROR. Must provide valid input for new Application.')
ELSE
BEGIN
    DECLARE @ID INT;
    SET @ID = (SELECT FLOOR(RAND()*90000000+10000000))
    SET @ApplicationID = @ID
	SET IDENTITY_INSERT dbo.Applications ON
    INSERT Applications (
        ApplicationID, CandidateID, JobID
    ) VALUES
    (@ID, @CandidateID, @JobID)
	SET IDENTITY_INSERT dbo.Applications OFF
END
GO

CREATE PROC spCreateCandidate
    @FirstName varchar(50) = NULL,
    @LastName varchar(50) = NULL,
    @Email varchar(50) = NULL,
    @Phone varchar(50) = NULL,
    @ShortProfile varchar(200) = 'None',
    @CandidateID INT = NULL OUTPUT
AS
IF(@FirstName IS NULL OR @LastName IS NULL OR @Email IS NULL OR @Phone IS NULL)
    PRINT('ERROR. Must provide valid input for new Candidate.')
ELSE
BEGIN
    DECLARE @ID INT;
    SET @ID = (SELECT FLOOR(RAND()*900000+100000))
    SET @CandidateID = @ID
	SET IDENTITY_INSERT dbo.Candidates ON
    INSERT Candidates(
        CandidateID, FirstName, LastName, Email, Phone, ShortProfile
    ) VALUES
    (@ID, @FirstName, @LastName, @Email, @Phone, @ShortProfile)
	SET IDENTITY_INSERT dbo.Candidates OFF
END
GO

CREATE PROC spCreateJob
    @Position varchar(50) = NULL,
    @Title varchar(50) = NULL,
    @Type varchar(50) = NULL,
    @Medium varchar(50) = NULL,
    @SlotsRemained INT = 1
AS
IF(@Position IS NULL OR @Title IS NULL OR @Type IS NULL OR @Medium IS NULL)
    PRINT('ERROR. Must provide valid input for new Job.')
ELSE
BEGIN
    DECLARE @ID INT;
    SET @ID = (SELECT FLOOR(RAND()*90000+10000))
    INSERT Jobs (
        JobID, Position, Title, Type, Medium, SlotsRemained
    ) VALUES
    (@ID, @Position, @Title, @Type, @Medium, @SlotsRemained)
END
GO

CREATE PROC spCreateDocument
    @CandidateID INT = 0
AS
IF(@CandidateID=0)
    PRINT('ERROR. Must provide valid input for new Document.')
ELSE
BEGIN
	DECLARE @DocumentID INT = FLOOR(RAND()*9000+1000)
    DECLARE @Domain varchar(50);
    SET @Domain = 'www.corp/humanresources/'
    DECLARE @CVs varchar(50);
    DECLARE @ReferenceLetter varchar(50);
    DECLARE @CoverLetter varchar(50);
    -- CHAR(RAND()*25+65) GET A-Z in ASCII 65-90
    SET @CVs = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
    SET @ReferenceLetter = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
    SET @CoverLetter = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
	SET IDENTITY_INSERT dbo.Documents ON
	INSERT Documents (
	    DocumentID, CandidateID, CVs, ReferenceLetter, CoverLetter
	) VALUES
	(@DocumentID, @CandidateID, @CVs, @ReferenceLetter, @CoverLetter)
	SET IDENTITY_INSERT dbo.Documents OFF
END
GO

--BEGIN TRY  
--    -- Generate a divide-by-zero error.  
--    SELECT 1/0;  
--END TRY  
--BEGIN CATCH  
--    SELECT  
--        ERROR_NUMBER() AS ErrorNumber  
--        ,ERROR_SEVERITY() AS ErrorSeverity  
--        ,ERROR_STATE() AS ErrorState  
--        ,ERROR_PROCEDURE() AS ErrorProcedure  
--        ,ERROR_LINE() AS ErrorLine  
--        ,ERROR_MESSAGE() AS ErrorMessage;  
--END CATCH;  
--GO  
CREATE PROC spCreateInterview
    @ApplicationID INT = 0,
    @Type VARCHAR(50) = 'Online'
AS
--IF(@ApplicationID=0 OR @ApplicationID IS NULL)
--    PRINT('ERROR. Must provide valid input to create interview. ' + 'ApplicationID=' + CONVERT(VARCHAR, @ApplicationID))
--	 --CONVERT(VARCHAR, ERROR_MESSAGE())
--ELSE
BEGIN
	DECLARE @InterviewersNo INT = (SELECT COUNT(*) FROM Interviewers)
	DECLARE @Offset INT = (FLOOR(RAND()*@InterviewersNo))
	DECLARE @InterviewerID INT = (
		SELECT InterviewerID
		FROM Interviewers 
		ORDER BY InterviewerID ASC
		OFFSET @Offset ROWS
		FETCH NEXT 1 ROWS ONLY
	)
    DECLARE @InterviewID INT = FLOOR(RAND()*90000+10000)
    DECLARE @StartDate datetime2 = DATEADD(WEEK, FLOOR(RAND()*7), GETDATE())
    DECLARE @InterviewsNo INT = dbo.fnGetInterviewNo(@ApplicationID)
	SET IDENTITY_INSERT dbo.Interviews ON
    INSERT Interviews(
        InterviewID, ApplicationID, InterviewerID, StartTime, EndTime, Round, Type
    ) VALUES
    (@InterviewID, @ApplicationID, @InterviewerID, @StartDate, DATEADD(HOUR, 1, @StartDate), @InterviewsNo+1, @Type)
	SET IDENTITY_INSERT dbo.Interviews OFF
END
GO

CREATE PROC spCreateTest
    @ApplicationID INT = 0,
    @Type VARCHAR(50) = 'Online'
AS
IF(@ApplicationID=0)
    PRINT('ERROR. Must provide valid input to create test.')
ELSE
BEGIN
    DECLARE @TestID INT = FLOOR(RAND()*90000000+10000000)
    DECLARE @StartDate datetime2 = DATEADD(WEEK, FLOOR(RAND()*7), GETDATE())
    DECLARE @Answer VARCHAR(500) = 'www.corp/humanresources/' + CONVERT(VARCHAR(50), FLOOR(RAND()*90000000+10000000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
	SET IDENTITY_INSERT dbo.Tests ON
    INSERT Tests (
        TestID, ApplicationID, StartTime, EndTime, Type, Round, Answers, Grade
    ) VALUES
    (@TestID, @ApplicationID, @StartDate, DATEADD(HOUR, 1, @StartDate), @Type, dbo.fnGetTestNo(@ApplicationID)+1, @Answer, 'Pending Grade')
	SET IDENTITY_INSERT dbo.Interviews OFF
END
GO

CREATE PROC spUpdateApplication
    @ApplicationID INT = 0,
    @Status varchar(50) = 'Under Consideration',
    @Type varchar(50) = 'Online',
    @AssignTest bit = 0
AS
IF(@ApplicationID=0 OR @Status=NULL)
    PRINT('ERROR. Must provide valid input to update application.')
ELSE
BEGIN
    UPDATE Applications
    SET Status = @Status
    WHERE ApplicationID = @ApplicationID
    IF(@Status NOT IN ('Under Consideration', 'Rejected'))
		BEGIN
        EXEC spCreateInterview @ApplicationID=@ApplicationID, @Type=@Type
        --PRINT('Candidate ' + CONVERT(VARCHAR(50), @CandidateID) + ' is under interview '+ fnGetCandidateInterviewNo(@ApplicationID) + '.')
		DECLARE @InterviewNo INT = dbo.fnGetInterviewNo(@ApplicationID)
		PRINT('Application ' + CONVERT(VARCHAR(50), @ApplicationID) + ' is under interview ' + CONVERT(VARCHAR(10), @InterviewNo) + '.')
        IF(@AssignTest=1)
            EXEC spCreateTest @ApplicationID=@ApplicationID
		END
    ELSE
        --PRINT('Candidate ' + CONVERT(VARCHAR(50), @CandidateID) + ' is rejected.')
		PRINT('Application ' + CONVERT(VARCHAR(50), @ApplicationID) + ' is rejected.')
END
GO
-- Triggers
-- CREATE TRIGGER tgJobAfterDelete
--     ON Jobs
--     AFTER DELETE
-- AS

--CREATE TRIGGER tgCleanInvalidCandidate
--    ON Candidates
--    AFTER INSERT, UPDATE
--AS
--IF EXISTS(
--    DELETE Candidates
--    WHERE CandidateID < 100000 OR CandidateID > 1000000
--)
--GO

CREATE TRIGGER tgCreateInterview 
	ON Interviews AFTER INSERT
AS 
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @InterviewID VARCHAR(50) = CONVERT(VARCHAR, (SELECT InterviewID FROM INSERTED))
PRINT('New Interview created, InterviewID=' + @InterviewID)
END
ELSE
PRINT('Interview insertion failed.')
GO

CREATE TRIGGER tgCreateCandidate 
	ON Candidates AFTER INSERT
AS 
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @CandidateID VARCHAR(50) = CONVERT(VARCHAR, (SELECT CandidateID FROM INSERTED))
PRINT('New Candidate created, CandidateID=' + @CandidateID)
END
ELSE
PRINT('Candidate insertion failed.')
GO

CREATE TRIGGER tgCreateApplication 
	ON Applications AFTER INSERT
AS 
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @ApplicationID VARCHAR(50) = CONVERT(VARCHAR, (SELECT ApplicationID FROM INSERTED))
PRINT('New Application created, ApplicationID=' + @ApplicationID)
END
ELSE
PRINT('Application insertion failed.')
GO

-- Security and Roles
-- reference from B 30
CREATE ROLE Interviewers
GRANT SELECT ON Candidates TO Interviewers
GRANT SELECT, UPDATE ON Applications TO Interviewers

CREATE ROLE OnboardingSpecialists
GRANT SELECT, UPDATE, INSERT ON Onboardings TO OnboardingSpecialists

CREATE ROLE Managers
GRANT SELECT, UPDATE, INSERT ON Departments TO Managers

CREATE ROLE Candidates
GRANT SELECT, UPDATE, DELETE, INSERT ON Documents TO Candidates
GRANT SELECT, UPDATE, DELETE ON Candidates TO Candidates
GRANT SELECT ON Applications TO Candidates

-- Transactions
-- Query 1
-- Populated values insertion
SET IDENTITY_INSERT [dbo].[Jobs] ON
INSERT Jobs (
    JobID, Position, Title, Type, Medium, SlotsRemained
) VALUES
(12355, 'Software Engineer', 'Software Engineer Roles', 'I', '80,000', 7)
SET IDENTITY_INSERT [dbo].[Jobs] OFF

SET IDENTITY_INSERT [dbo].[Candidates] ON
INSERT Candidates (
    CandidateID, FirstName, LastName, Email, Phone, ShortProfile
) VALUES
(749303, 'Davison', 'Miles', 'DavMi@gmail.com', '315-882-0365', 'Strong Candidate')
SET IDENTITY_INSERT [dbo].[Candidates] OFF

SET IDENTITY_INSERT [dbo].[Departments] ON
INSERT Departments (
    DepartmentID, DepartmentName, ChairmanName, Email, Phone
) VALUES
(390, 'Recruitment', 'Braddle Anthony', 'Recruitment@corp.com', '800-329-9977')
SET IDENTITY_INSERT [dbo].[Departments] OFF

SET IDENTITY_INSERT [dbo].[Documents] ON
INSERT Documents (
    DocumentID, CandidateID, CVs, ReferenceLetter, CoverLetter
) VALUES
(3384, 749303, 'www.corp/humanresources/38428gq', 'www.corp/humanresources/38411nu', 'www.corp/humanresources/55428qq')
SET IDENTITY_INSERT [dbo].[Documents] OFF

SET IDENTITY_INSERT [dbo].[Applications] ON
INSERT Applications (
    ApplicationID, CandidateID, JobID, Status
) VALUES
(13765338, 749303, 12355, 'Under Interview')
SET IDENTITY_INSERT [dbo].[Applications] OFF

SET IDENTITY_INSERT [dbo].[Interviewers] ON
INSERT Interviewers (
    InterviewerID, FirstName, LastName, Email, Phone, Title, DepartmentID
) VALUES
(3282, 'Kevin', 'Morris', 'KevMo@gmail.com', '559-233-7193', 'Senior Project Manager', 390),
(8713, 'Gary', 'Aztek', 'GaryAztek@gamil.com', '559-115-3108', 'Senior Project Manager', 390)
SET IDENTITY_INSERT [dbo].[Interviewers] OFF

SET IDENTITY_INSERT [dbo].[Interviews] ON
INSERT Interviews (
    InterviewID, ApplicationID, InterviewerID, StartTime, EndTime, Round, Type
) VALUES
(48292, 13765338, 3282, '2022-07-17 02:00:00', '2022-07-17 03:00:00', 1, 'Online')
SET IDENTITY_INSERT [dbo].[Interviews] OFF

SET IDENTITY_INSERT [dbo].[Tests] ON
INSERT Tests (
    TestID, ApplicationID, StartTime, EndTime, Type, Round, Answers, Grade
) VALUES
(38294233, 13765338, '2022-07-10 03:00:00', '2022-07-10 04:00:00', 'Online', 1, 'www.corp/humanresources/38411313nxad', 'Passed'),
(38294234, 13765338, '2022-07-16 03:00:00', '2022-07-16 04:00:00', 'Online', 2, 'www.corp/humanresources/48031313vpqu', 'Failed')
SET IDENTITY_INSERT [dbo].[Tests] OFF

SET IDENTITY_INSERT [dbo].[Evaluations] ON
INSERT Evaluations(
    EvaluationID, ApplicationID, Notes, Result
) VALUES
(38317920, 13765338, 'Good', 'Passed')
SET IDENTITY_INSERT [dbo].[Evaluations] OFF

SET IDENTITY_INSERT [dbo].[Reimbursements] ON
INSERT Reimbursements (
    ReimbursementID, ApplicationID, Request, Processed, Amount
) VALUES
(24898, 13765338, 'Accepted', 'Processing', '130000')
SET IDENTITY_INSERT [dbo].[Reimbursements] OFF

SET IDENTITY_INSERT [dbo].[Onboardings] ON
INSERT Onboardings (
    OnboardingID, CandidateID, StartDate
) VALUES
(938492, 749303, '2022-08-10 12:00:00')
SET IDENTITY_INSERT [dbo].[Onboardings] OFF
