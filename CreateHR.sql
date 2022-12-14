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
CREATE TABLE [dbo].[Departments](
	[DepartmentID] [int] NOT NULL,
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

CREATE SCHEMA Recruitment
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recruitment].[Jobs] (
    [JobID] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentID] [int] NOT NULL -- alias job categories as well
		REFERENCES dbo.Departments (DepartmentID),
	[Title] [varchar](50) NOT NULL,
	[Ranking] [varchar](50) NOT NULL DEFAULT 'I',
	[Type] [varchar](50) NOT NULL DEFAULT 'Full-time',
	[Status] [varchar](50) NOT NULL DEFAULT 'Opened',
	[StartDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[BaseSalary] [smallmoney] NOT NULL DEFAULT 40000,
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
CREATE TABLE [Recruitment].[Candidates](
	[CandidateID] [int] NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
    [LastName] [varchar](50) NOT NULL,
    [Email] [varchar](50) NOT NULL UNIQUE,
    [Phone] [varchar](50) NOT NULL UNIQUE,
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
CREATE TABLE [Recruitment].[Documents](
	[DocumentID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [int] NOT NULL
        REFERENCES Recruitment.Candidates (CandidateID),
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
CREATE TABLE [Recruitment].[Applications](
	[ApplicationID] [int] IDENTITY(1,1) NOT NULL,
	[CandidateID] [int] NOT NULL
        REFERENCES Recruitment.Candidates (CandidateID),
    [JobID] [int] NOT NULL
        REFERENCES Recruitment.Jobs (JobID),
    [Status] [varchar](50) NULL DEFAULT 'Under Consideration',    
	[Platform] [varchar](50) NULL DEFAULT 'Other',
	[Salary] [smallmoney] NULL,
	[StartDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[EndDate] [datetime] NULL
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
CREATE TABLE [Recruitment].[Interviewers](
	[InterviewerID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
    [LastName] [varchar](50) NOT NULL,
    [Email] [varchar](50) NOT NULL UNIQUE,
    [Phone] [varchar](50) NOT NULL UNIQUE,
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
CREATE TABLE [Recruitment].[Interviews](
	[InterviewID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Recruitment.Applications (ApplicationID),
    --[InterviewerID] [int] NOT NULL
    --    REFERENCES Recruitment.Interviewers (InterviewerID),
    [StartTime] [datetime2] NOT NULL,
    [EndTime] [datetime2] NOT NULL,
    [Round] [int] NULL DEFAULT 1,
	[Result] [varchar](50) NULL DEFAULT 'Pending Start',
    [Type] [varchar](50) NOT NULL,
	[ReviewFromCandidate] [varchar](100) NULL DEFAULT 'good interview experience',
	[ReviewToCandidate] [varchar](100) NULL DEFAULT 'excellent candidate'
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
CREATE TABLE [Recruitment].[Tests](
	[TestID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Recruitment.Applications (ApplicationID),
    [StartTime] [datetime2] NOT NULL,
    [EndTime] [datetime2] NOT NULL,
    [Type] [varchar](50) NULL DEFAULT 'Online',
    [Round] [int] NULL DEFAULT 1,
    [Answers] [varchar](50) NOT NULL,
    [Grade] [varchar](50) NOT NULL,
	[ReviewFromCandidate] [varchar](100) NULL DEFAULT 'great test experience',
	[ReviewToCandidate] [varchar](100) NULL DEFAULT 'excellent candidate'
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
CREATE TABLE [Recruitment].[InterviewersGroup](
	[InterviewID] [int] NULL
		REFERENCES Recruitment.Interviews (InterviewID),
	[TestID] [int] NULL
		REFERENCES Recruitment.Tests (TestID),
    [ChiefInterviewer] [int] NOT NULL
		REFERENCES Recruitment.Interviewers (InterviewerID),
	[ViceInterviewer] [int] NOT NULL
		REFERENCES Recruitment.Interviewers (InterviewerID),
    [InterviewerMember1] [int] NULL
		REFERENCES Recruitment.Interviewers (InterviewerID),
    [InterviewerMember2] [int] NULL
		REFERENCES Recruitment.Interviewers (InterviewerID),
    [InterviewerMember3] [int] NULL
		REFERENCES Recruitment.Interviewers (InterviewerID),
) ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Recruitment].[Evaluations](
	[EvaluationID] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationID] [int] NOT NULL
        REFERENCES Recruitment.Applications (ApplicationID),
    [Notes] [varchar](50) NOT NULL DEFAULT 'None',
    [Result] [varchar](50) NOT NULL,
	[Date] [datetime2] NOT NULL DEFAULT GETDATE(),
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
CREATE TABLE [Recruitment].[Reimbursements](
	[ReimbursementID] [int] NOT NULL UNIQUE,
	[ApplicationID] [int] NOT NULL
        REFERENCES Recruitment.Applications (ApplicationID),
    [Required] bit NOT NULL DEFAULT 1,
    [Status] [varchar](50) NOT NULL DEFAULT 'Submitted',
    [AmountApproved] [smallmoney] NOT NULL DEFAULT 0,
	[Expense] [smallmoney] NOT NULL DEFAULT 0,
	[AirlineReservationDetail] [varchar](100) NOT NULL,
	[HotelReservationDetail] [varchar](100) NOT NULL,
	[CarRentalDetail] [varchar](100) NOT NULL,
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
CREATE TABLE [Recruitment].[Onboardings](
	[OnboardingID] [int] NOT NULL,
	[ApplicationID] [int] NOT NULL 
        REFERENCES Recruitment.Applications (ApplicationID),
	[SpecialistID] [int] NOT NULL,
	[BackgroundCheck] [bit] NOT NULL DEFAULT 1,
    [WorkingDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [AttendingDate] [datetime] NOT NULL DEFAULT GETDATE(),
	[Status] [varchar](30) NOT NULL DEFAULT 'Pending onboard',
    PRIMARY KEY CLUSTERED 
    (
        [OnboardingID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [Recruitment].[Blacklist](
	BlacklistID [int] IDENTITY(1,1) NOT NULL,
	CandidateID [int] NOT NULL 
        REFERENCES Recruitment.Candidates (CandidateID),
    [ProcessedDate] [datetime2] NOT NULL DEFAULT GETDATE(),
	[Reason] [varchar](30) NOT NULL DEFAULT 'Failed to onboard without explanation',
    PRIMARY KEY CLUSTERED 
    (
        [BlacklistID] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Views

CREATE VIEW Recruitment.AllJobs AS
    SELECT *
    FROM Recruitment.Jobs
GO

CREATE VIEW ApplicationAcceptRateOverall AS
	SELECT 
		(SELECT COUNT(*) FROM Recruitment.Applications WHERE Status='Accepted') AS AcceptApplicationNo,
		(SELECT COUNT(*) FROM Recruitment.Applications) AS TotalApplicationNo,
		(SELECT COUNT(*) FROM Recruitment.Applications WHERE Status='Accepted')/(SELECT COUNT(*) FROM Recruitment.Applications) AS AcceptRate
GO

CREATE VIEW OnboardDateAvg AS
	SELECT
		AVG(DATEDIFF(DAY, AttendingDate, WorkingDate)) AS OnboardDateAvg
	FROM Recruitment.Onboardings
	WHERE WorkingDate IS NOT NULL
GO

CREATE VIEW AllCandidateInfo AS
	SELECT C.CandidateID, FirstName, LastName, Email, Phone,		
		(SELECT COUNT(*) FROM Recruitment.Applications WHERE CandidateID=CandidateID) AS ApplicationTime,
		A.Status AS LatestStatus
	FROM Recruitment.Candidates C LEFT JOIN Recruitment.Applications A
		ON C.CandidateID=A.CandidateID
GO

CREATE VIEW BlacklistFrequency AS
	SELECT
		(SELECT COUNT(*) 
			--CandidateID, ProcessedDate, Reason
		FROM Recruitment.Blacklist
		WHERE ProcessedDate > DATEFROMPARTS(DATEPART(YEAR, GETDATE()),1,1)
		) AS CurrentYearBlacklistNo,

		(SELECT COUNT(*) 
		FROM Recruitment.Blacklist
		WHERE ProcessedDate > DATEFROMPARTS(DATEPART(YEAR, GETDATE())-1,1,1)
			AND ProcessedDate < DATEFROMPARTS(DATEPART(YEAR, GETDATE())-1,12,31)
		) AS LastYearBlacklistNo
GO

-- Functions
-- Invalid use of a side-effecting operator 'rand' within a function.
CREATE FUNCTION dbo.fnGetRandomDate()
RETURNS DATETIME AS
BEGIN
	RETURN GETDATE()
END
GO

CREATE FUNCTION dbo.fnGetBlacklistNo()
RETURNS INT AS
BEGIN
	RETURN (SELECT COUNT(*) FROM Recruitment.Blacklist)
END
GO
-- Can not use PRINT in functions
CREATE FUNCTION dbo.fnGetInterviewNo(
    @ApplicationID INT = 0
) RETURNS INT AS
BEGIN
RETURN(
	SELECT COUNT(*)
	FROM Recruitment.Interviews I 
	WHERE I.ApplicationID=@ApplicationID
)
END
GO

CREATE FUNCTION fnGetTestNo(
    @ApplicationID INT = 0
) RETURNS INT AS
BEGIN
	DECLARE @TestNo INT = (
		SELECT COUNT(*)
		FROM Recruitment.Tests T
		WHERE T.ApplicationID=@ApplicationID
	)
RETURN @TestNo
END
GO

-- Stored Procedure
CREATE PROC spGetRanLenNo
	@Length INT = 1,
	@Number INT OUTPUT
AS
	DECLARE @Base INT = CONVERT(INT, POWER(10, (@Length-1)))
	SET @Number = CAST(FLOOR(RAND()*9*@Base+@Base) AS INT)
GO

CREATE PROC spGetRanAlphaChar
	@Length INT = 1,
	@String VARCHAR = '' OUTPUT
AS
	WHILE LEN(@String) < @Length
	BEGIN
		-- Get a Character from A-Z
		SET @String = @String + CHAR(RAND()*25+65) 
	END
GO

CREATE PROC spCreateReimbursement
	@ApplicationID INT = NULL,
	@AirlineReservationDetails VARCHAR(100) = NULL,
	@HotelReservationDetails VARCHAR(100) = NULL,
	@CarRentalDetails VARCHAR(100) = NULL,
	@Expense SMALLMONEY = 0
AS
	DECLARE @No INT, @Str VARCHAR(50)
	EXEC spGetRanLenNo @Length=8, @Number=@No OUTPUT
	DECLARE @ReimbursementID INT = @No
	IF(@AirlineReservationDetails IS NULL)
	BEGIN
		EXEC spGetRanLenNo @Length=8, @Number=@No OUTPUT
		EXEC spGetRanAlphaChar @Length=4, @String=@Str OUTPUT
		DECLARE @AirlineReservationDetail VARCHAR(100) = CAST(@No AS VARCHAR) + @Str
	END
	IF(@HotelReservationDetails IS NULL)
	BEGIN
		EXEC spGetRanLenNo @Length=8, @Number=@No OUTPUT
		EXEC spGetRanAlphaChar @Length=4, @String=@Str OUTPUT
		DECLARE @HotelReservationDetail VARCHAR(100) = CAST(@No AS VARCHAR) + @Str
	END
	IF(@CarRentalDetails IS NULL)
	BEGIN
		EXEC spGetRanLenNo @Length=8, @Number=@No OUTPUT
		EXEC spGetRanAlphaChar @Length=4, @String=@Str OUTPUT
		DECLARE @CarRentalDetail VARCHAR(100) = CAST(@No AS VARCHAR) + @Str
	END
	IF(@Expense=0)
	BEGIN
		EXEC spGetRanLenNo @Length=4, @Number=@No OUTPUT
		SET @Expense = @No
	END
	INSERT Recruitment.Reimbursements(
		ReimbursementID, ApplicationID, Required, Status, AmountApproved, Expense, AirlineReservationDetail, HotelReservationDetail, CarRentalDetail	
	) VALUES
	(@ReimbursementID, @ApplicationID, 1, 'Processing', 0, @Expense, @AirlineReservationDetails, @HotelReservationDetails, @CarRentalDetails)
GO

CREATE PROC spCreateApplication
    @CandidateID INT = 0,
    @JobID INT = 0,
	@Platform VARCHAR(50) = 'Career Site',
    @ApplicationID INT = 0 OUTPUT
AS
IF(@CandidateID=0 OR @JobID=0)
    PRINT('ERROR. Must provide valid input for new Application.')
ELSE
BEGIN
    DECLARE @ID INT;
    SET @ID = (SELECT FLOOR(RAND()*90000000+10000000))
    SET @ApplicationID = @ID
	SET IDENTITY_INSERT Recruitment.Applications ON
    INSERT Recruitment.Applications (
        ApplicationID, CandidateID, JobID, Platform, StartDate
    ) VALUES
    (@ID, @CandidateID, @JobID, @Platform, GETDATE())
	SET IDENTITY_INSERT Recruitment.Applications OFF
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
	IF(EXISTS(SELECT Email FROM Recruitment.Candidates WHERE Email=@Email))
	BEGIN
		SET @CandidateID=(SELECT CandidateID FROM Recruitment.Candidates WHERE Email=@Email)
		PRINT('Candidate ' + CAST(@CandidateID AS VARCHAR) + ' is already created.')
	END
	ELSE
	BEGIN
		--SET IDENTITY_INSERT Recruitment.Candidates ON
		INSERT Recruitment.Candidates(
			CandidateID, FirstName, LastName, Email, Phone, ShortProfile
		) VALUES
		(@ID, @FirstName, @LastName, @Email, @Phone, @ShortProfile)
		--SET IDENTITY_INSERT Recruitment.Candidates OFF
	END
END
GO

CREATE PROC spCreateOnboarding
	@ApplicationID INT = NULL
AS
BEGIN
IF(@ApplicationID IS NULL)
    PRINT('ERROR. Must provide valid input for new Onboarding.')
ELSE
BEGIN
	DECLARE @No INT, @Str VARCHAR(50)
	EXEC spGetRanLenNo @Length=6, @Number=@No OUTPUT
	DECLARE @OnboardingID INT = @No
	EXEC spGetRanLenNo @Length=6, @Number=@No OUTPUT
	DECLARE @SpecialistID INT = @No
	INSERT Recruitment.Onboardings(
	    OnboardingID, ApplicationID, SpecialistID, BackgroundCheck, WorkingDate, AttendingDate, Status		
	) VALUES
	(@OnboardingID, @ApplicationID, @SpecialistID, 0, GETDATE(), NULL, 'Pending Onboard')
END
END
GO

CREATE PROC spCreateDocument
    @CandidateID INT = 0
AS
IF(@CandidateID=0)
    PRINT('ERROR. Must provide valid input for new Document.')
ELSE
BEGIN
	DECLARE @No INT, @Str VARCHAR(50)
	EXEC spGetRanLenNo @Length=4, @Number=@No OUTPUT
	DECLARE @DocumentID INT = @No
    DECLARE @Domain varchar(50);
    SET @Domain = 'www.goodcompany/humanresources/'
    DECLARE @CVs varchar(50);
    DECLARE @ReferenceLetter varchar(50);
    DECLARE @CoverLetter varchar(50);
    -- CHAR(RAND()*25+65) GET A-Z in ASCII 65-90
    SET @CVs = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
    SET @ReferenceLetter = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
    SET @CoverLetter = @Domain + CONVERT(VARCHAR(50), FLOOR(RAND()*90000+10000)) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
	SET IDENTITY_INSERT Recruitment.Documents ON
	INSERT Recruitment.Documents (
	    DocumentID, CandidateID, CVs, ReferenceLetter, CoverLetter
	) VALUES
	(@DocumentID, @CandidateID, @CVs, @ReferenceLetter, @CoverLetter)
	SET IDENTITY_INSERT Recruitment.Documents OFF
END
GO

CREATE PROC spCreateInterview
    @ApplicationID INT = 0,
    @Type VARCHAR(50) = 'Online',
	@InterviewID INT = NULL OUTPUT
AS
--IF(@ApplicationID=0 OR @ApplicationID IS NULL)
--    PRINT('ERROR. Must provide valid input to create interview. ' + 'ApplicationID=' + CONVERT(VARCHAR, @ApplicationID))
--ELSE
BEGIN
    DECLARE @ID INT = FLOOR(RAND()*90000+10000)
    DECLARE @StartDate datetime2 = DATEADD(WEEK, FLOOR(RAND()*7), GETDATE())
    DECLARE @InterviewsNo INT = dbo.fnGetInterviewNo(@ApplicationID)
	SET IDENTITY_INSERT Recruitment.Interviews ON
    INSERT Recruitment.Interviews(
        InterviewID, ApplicationID, StartTime, EndTime, Round, Result, Type
    ) VALUES
    (@ID, @ApplicationID, @StartDate, DATEADD(HOUR, 1, @StartDate), @InterviewsNo+1, 'Pending Start', @Type)
	SET @InterviewID=@ID
	PRINT('ApplicationID ' + CONVERT(VARCHAR, @ApplicationID) + ' assigned new interview for round ' + CONVERT(VARCHAR, @InterviewsNo+1) + '.')
	SET IDENTITY_INSERT Recruitment.Interviews OFF
END
GO

CREATE PROC spCreateTest
    @ApplicationID INT = 0,
    @Type VARCHAR(50) = 'Online',
	@TestID INT = NULL OUTPUT
AS
--IF(@ApplicationID=0)
--    PRINT('ERROR. Must provide valid input to create test.')
--ELSE
BEGIN
    DECLARE @ID INT = FLOOR(RAND()*90000000+10000000)
    --DECLARE @ID INT = dbo.fnGetRandomLenNo(8)
    DECLARE @StartDate datetime2 = DATEADD(WEEK, FLOOR(RAND()*7), GETDATE())
    DECLARE @Answer VARCHAR(500) = 'www.goodcompany/humanresources/' + CONVERT(VARCHAR, CONVERT(INT, FLOOR(RAND()*90000000+10000000))) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65) + CHAR(RAND()*25+65)
	DECLARE @Round INT = dbo.fnGetTestNo(@ApplicationID)+1
	SET IDENTITY_INSERT Recruitment.Tests ON
    INSERT Recruitment.Tests (
        TestID, ApplicationID, StartTime, EndTime, Type, Round, Answers, Grade
    ) VALUES
    (CONVERT(VARCHAR, @ID), @ApplicationID, @StartDate, DATEADD(HOUR, 1, @StartDate), @Type, @Round, @Answer, 'Pending Grade')
	SET @TestID=@ID
	SET IDENTITY_INSERT Recruitment.Interviews OFF
	PRINT('ApplicationID ' + CONVERT(VARCHAR, @ApplicationID) + ' assigned new test for round ' + CONVERT(VARCHAR, @Round) + '.')
END
GO

CREATE PROC spCreateInterviewerGroup
	@InterviewID INT = NULL,
	@TestID INT = NULL
AS
IF(@InterviewID=NULL AND @TestID=NULL)
    PRINT('ERROR. Must provide valid input to create interviewer group.')
ELSE
BEGIN
	DECLARE @InterviewerNo INT = FLOOR(RAND()*3+2)
	DECLARE @Interviewers TABLE (InterviewerID INT)
	WHILE (SELECT COUNT(*) FROM @Interviewers) < @InterviewerNo
	BEGIN
		DECLARE @Offset INT = FLOOR(RAND()*(SELECT COUNT(*) FROM Recruitment.Interviewers))
		DECLARE @InterviewerID INT = (
			SELECT InterviewerID FROM Recruitment.Interviewers
			ORDER BY InterviewerID ASC
			OFFSET @Offset ROWS
			FETCH NEXT 1 ROWS ONLY
			)
		--DECLARE @InterviewerID INT = dbo.fnGetRandomID('Recruitment.Interviewers')
		IF (@InterviewerID NOT IN (SELECT * FROM @Interviewers))
			INSERT @Interviewers VALUES (@InterviewerID)
	END
	DECLARE @Chief INT = (SELECT TOP 1 * FROM @Interviewers)
	DELETE @Interviewers WHERE InterviewerID = @Chief
	DECLARE @Vice INT = (SELECT TOP 1 * FROM @Interviewers)
	DELETE @Interviewers WHERE InterviewerID = @Chief
	DECLARE @Member1 INT = NULL, @Member2 INT = NULL, @Member3 INT = NULL
	IF((SELECT COUNT(*) FROM @Interviewers) > 0)
	BEGIN
		SET @Member1 = (SELECT TOP 1 * FROM @Interviewers)
		DELETE @Interviewers WHERE InterviewerID = @Member1
	END
	IF((SELECT COUNT(*) FROM @Interviewers) > 0)
	BEGIN
		SET @Member2 = (SELECT TOP 1 * FROM @Interviewers)
		DELETE @Interviewers WHERE InterviewerID = @Member2
	END
	IF((SELECT COUNT(*) FROM @Interviewers) > 0)
	BEGIN
		SET @Member3 = (SELECT TOP 1 * FROM @Interviewers)
		DELETE @Interviewers WHERE InterviewerID = @Member3
	END
	INSERT Recruitment.InterviewersGroup(
		InterviewID, TestID, ChiefInterviewer, ViceInterviewer, InterviewerMember1, InterviewerMember2, InterviewerMember3
	) VALUES
	(@InterviewID, @TestID, @Chief, @Vice, @Member1, @Member2, @Member3)
	IF(@InterviewID IS NOT NULL)
		PRINT('InterviewID=' + CONVERT(VARCHAR, @InterviewID) + ' is assigned interviewer group.')
	ELSE IF(@TestID IS NOT NULL)
		PRINT('TestID=' + CAST(@TestID AS VARCHAR) + ' is assigned interviewer group.')
END
GO


CREATE PROC spUpdateApplication
    @ApplicationID INT = 0,
    @Status varchar(50) = 'Under Consideration',
    @Type varchar(50) = 'Online',
	@Salary smallmoney = NULL,
    @AssignTest bit = 0,
	@AssignInterview bit = 0
AS
--IF(@ApplicationID=0 OR @Status=NULL)
--    PRINT('ERROR. Must provide valid input to update application.')
--ELSE
BEGIN
	DECLARE @JobID INT = (SELECT JobID FROM Recruitment.Applications WHERE ApplicationID=@ApplicationID)
	DECLARE @CandidateID INT = (SELECT CandidateID FROM Recruitment.Applications WHERE ApplicationID=@ApplicationID)
IF(@Status = 'Offered')
BEGIN
	DECLARE @Slots INT = 
	(SELECT SlotsRemained FROM Recruitment.Jobs WHERE JobID=@JobID)
	IF(@Slots>0)
	BEGIN
		UPDATE Recruitment.Jobs
		SET SlotsRemained=@Slots-1
		WHERE JobID=@JobID
		PRINT('Job ' + CAST(@JobID AS VARCHAR) + ' is ' + @Status + ', JobID=' + CAST(@JobID AS VARCHAR) + ', ApplicationID=' + CAST(@ApplicationID AS VARCHAR) + '.')
	END
	ELSE
	BEGIN
		SET @Status = 'on-call for next job opportunity'
		PRINT('Candidate is on-call for next job opportunity. ApplicationID=' + CAST(@ApplicationID AS VARCHAR) + ', JobID=' + CAST(@JobID AS VARCHAR) + '.')
	END
END
ELSE IF(@Status = 'Waiting')
BEGIN
	PRINT('Candidate filed an complaint on review process. ApplicationID=' + CAST(@ApplicationID AS VARCHAR) + ', JobID=' + CAST(@JobID AS VARCHAR) + '.')
END
ELSE IF(@Status = 'Negotiating')
BEGIN
	PRINT('Job ' + CAST(@JobID AS VARCHAR) + ' is ' + @Status + ', JobID=' + CAST(@JobID AS VARCHAR) + ', ApplicationID=' + CAST(@ApplicationID AS VARCHAR) + '.')
	UPDATE Recruitment.Applications
	SET Salary=@Salary
	WHERE ApplicationID = @ApplicationID	
END
ELSE IF(@Status = 'Declined')
BEGIN
	SET @Slots = 
	(SELECT SlotsRemained FROM Recruitment.Jobs WHERE JobID=@JobID)
	UPDATE Recruitment.Jobs
	SET SlotsRemained=@Slots+1
	WHERE JobID=@JobID
	PRINT('Job is Declined by candidate. JobID=' + CAST(@JobID AS VARCHAR) + ', ApplicationID=' + CAST(@ApplicationID AS VARCHAR) +'.')
END
ELSE IF(@Status = 'Accepted')
BEGIN
	PRINT('Job ' + CAST(@JobID AS VARCHAR) + ' is ' + @Status + ', JobID=' + CAST(@JobID AS VARCHAR) + ', ApplicationID=' + CAST(@ApplicationID AS VARCHAR) + '.')
	EXEC spCreateOnboarding @ApplicationID=@ApplicationID
END
ELSE IF(@Status = 'Rejected')
BEGIN
	PRINT('Candidate is rejected. Application ' + CONVERT(VARCHAR(50), @ApplicationID) + ' is archived.')
END
ELSE 
	--IF(@Status <> 'Rejected')
BEGIN
	PRINT('Application ' + CONVERT(VARCHAR(50), @ApplicationID) + ' is under ' + @Status + '.')
	IF(@Status='OnSite')
	BEGIN
		EXEC spCreateReimbursement @ApplicaionID=@ApplicationID
	END
	IF(@AssignInterview=1)
	BEGIN
		DECLARE @InterviewID INT = NULL
		EXEC spCreateInterview @ApplicationID=@ApplicationID, @Type=@Type, @InterviewID=@InterviewID OUTPUT
		DECLARE @InterviewNo INT = dbo.fnGetInterviewNo(@ApplicationID)
		--PRINT('Application ' + CONVERT(VARCHAR(50), @ApplicationID) + ' is under interview ' + CONVERT(VARCHAR(10), @InterviewNo) + '.')
		EXEC spCreateInterviewerGroup @InterviewID=@InterviewID, @TestID=NULL
	END
    IF(@AssignTest=1)
	BEGIN
		DECLARE @TestID INT = NULL
        EXEC spCreateTest @ApplicationID=@ApplicationID, @Type=@Type, @TestID=@TestID OUTPUT
		EXEC spCreateInterviewerGroup @InterviewID=NULL, @TestID=@TestID
	END
END
	UPDATE Recruitment.Applications
	SET Status = @Status
	WHERE ApplicationID = @ApplicationID	
	-- createEvaluation
	DECLARE @No INT, @Str VARCHAR(50)
	EXEC spGetRanLenNo @Length=8, @Number=@No OUTPUT
	DECLARE @EvaluationID INT = @No
	SET IDENTITY_INSERT [Recruitment].[Evaluations] ON
	INSERT Recruitment.Evaluations(
		EvaluationID, ApplicationID, Notes, Result, Date
	) VALUES
	(@EvaluationID, @ApplicationID, 'None', @Status, GETDATE())
	SET IDENTITY_INSERT [Recruitment].[Evaluations] OFF
END
GO

CREATE PROC spUpdateTest
	@ApplicationID INT = 0,
	@Grade VARCHAR(30) = 'Failed'
AS
IF(@ApplicationID=0 OR @Grade=NULL)
    PRINT('ERROR. Must provide valid input to update test.')
ELSE
BEGIN
DECLARE @Round INT = (SELECT MAX(Round) FROM Recruitment.Tests WHERE ApplicationID=@ApplicationID)
UPDATE Recruitment.Tests
SET Grade=@Grade
WHERE ApplicationID = @ApplicationID AND
	Round = @Round
PRINT('ApplicationID ' + CONVERT(VARCHAR, @ApplicationID) + ' ' + @Grade + ' Test ' + CONVERT(VARCHAR, @Round) + '.')
END
GO

CREATE PROC spUpdateInterview
	@ApplicationID INT = 0,
	@Result VARCHAR(30) = 'Pending'
AS
IF(@ApplicationID=0 OR @Result=NULL)
    PRINT('ERROR. Must provide valid input to update Interview.')
ELSE
BEGIN
DECLARE @Round INT = (SELECT MAX(Round) FROM Recruitment.Tests WHERE ApplicationID=@ApplicationID)
UPDATE Recruitment.Interviews
SET Result=@Result
WHERE ApplicationID = @ApplicationID AND
	Round = @Round
PRINT('ApplicationID ' + CONVERT(VARCHAR, @ApplicationID) + ' is ' + @Result + ' in Interview ' + CONVERT(VARCHAR, @Round) + '.')
END
GO

CREATE PROC spUpdateReimbursement
	@ReimbursementID INT = NULL,
	@AmountApproved SMALLMONEY = NULL,
	@AirlineReservationDetails VARCHAR(100) = NULL,
	@HotelReservationDetails VARCHAR(100) = NULL,
	@CarRentalDetails VARCHAR(100) = NULL,
	@Status VARCHAR(50) = 'Processed',
	@Required BIT = 1
AS
IF(@ReimbursementID=NULL OR @AmountApproved=NULL)
    PRINT('ERROR. Must provide valid input to update Reimbursement.')
ELSE
BEGIN
	IF(@AmountApproved IS NULL)
		SET @AmountApproved = (SELECT Expense FROM Recruitment.Reimbursements WHERE ReimbursementID=@ReimbursementID)
	UPDATE Recruitment.Reimbursements
	SET 
		AmountApproved=@AmountApproved,
		Status=@Status
		--AirlineReservationDetails = @AirlineReservationDetails,
		--HotelReservationDetails = @HotelReservationDetails,
		--CarRentalDetails = @CarRentalDetails
	WHERE ReimbursementID=@ReimbursementID
END
GO

CREATE PROC spUpdateOnboarding
	@OnboardingID INT = NULL,
	@BackgroundCheck BIT = 1,
	@ApplicationID INT = NULL,
	@AttendingDate DATETIME = NULL,
	@Status VARCHAR(30) = 'Onboard'
AS
BEGIN
IF((@OnboardingID IS NULL) AND (@ApplicationID IS NULL))
    PRINT('ERROR. Must provide valid input to update Onboarding.')
ELSE
BEGIN
	IF(@AttendingDate IS NULL OR @AttendingDate=0)
		SET @AttendingDate = GETDATE()
	UPDATE Recruitment.Onboardings
	SET
		BackgroundCheck=@BackgroundCheck,
		AttendingDate=@AttendingDate,
		Status=@Status
	WHERE OnboardingID=@OnboardingID OR ApplicationID=@ApplicationID
END
END
GO

CREATE PROC spPutCandidateInBlacklist
	@CandidateID INT = NULL,
	@Reason VARCHAR(50) = NULL
AS
BEGIN
IF(@CandidateID IS NULL)
    PRINT('ERROR. Must provide valid CandidateID to update Blacklist.')
ELSE
BEGIN
	INSERT Recruitment.Blacklist(
		CandidateID, ProcessedDate, Reason
	) VALUES
	(@CandidateID, GETDATE(), @Reason)
END
END
GO
-- Security and Roles
-- reference from B 30
IF EXISTS(SELECT name FROM master.sys.server_principals WHERE name = 'Interviewers')
	DROP LOGIN Interviewers
GO
CREATE LOGIN Interviewers WITH PASSWORD = 'Interviewers',
	DEFAULT_DATABASE = HumanResource
CREATE USER Illinor FOR LOGIN Interviewers
CREATE ROLE Interviewers
ALTER ROLE Interviewers ADD MEMBER Illinor
GRANT SELECT ON Recruitment.Candidates TO Interviewers
GRANT SELECT, UPDATE ON Recruitment.Applications TO Interviewers
GO

IF EXISTS(SELECT name FROM master.sys.server_principals WHERE name = 'OnboardingSpecialists')
	DROP LOGIN OnboardingSpecialists
GO
CREATE LOGIN OnboardingSpecialists WITH PASSWORD = 'OnboardingSpecialists',
	DEFAULT_DATABASE = HumanResource
CREATE USER Ottoman FOR LOGIN OnboardingSpecialists
CREATE ROLE OnboardingSpecialists
ALTER ROLE OnboardingSpecialists ADD MEMBER Ottoman
GRANT SELECT, UPDATE, INSERT ON Recruitment.Onboardings TO OnboardingSpecialists

IF EXISTS(SELECT name FROM master.sys.server_principals WHERE name = 'Managers')
	DROP LOGIN Managers
GO
CREATE LOGIN Managers WITH PASSWORD = 'Managers',
	DEFAULT_DATABASE = HumanResource
CREATE USER Madison FOR LOGIN Managers
CREATE ROLE Managers
ALTER ROLE Managers ADD MEMBER Madison
GRANT SELECT, UPDATE, INSERT ON dbo.Departments TO Managers

IF EXISTS(SELECT name FROM master.sys.server_principals WHERE name = 'Candidates')
	DROP LOGIN Candidates
GO
CREATE LOGIN Candidates WITH PASSWORD = 'Candidates',
	DEFAULT_DATABASE = HumanResource
CREATE USER Charlie FOR LOGIN Candidates
CREATE ROLE Candidates
ALTER ROLE Candidates ADD MEMBER Charlie
GRANT SELECT, UPDATE, DELETE, INSERT ON Recruitment.Documents TO Candidates
GRANT SELECT, UPDATE, DELETE ON Recruitment.Candidates TO Candidates
GRANT SELECT ON Recruitment.Applications TO Candidates

-- Populated values insertion
INSERT dbo.Departments (
    DepartmentID, DepartmentName, ChairmanName, Email, Phone
) VALUES
(390, 'Recruitment', 'Braddle Anthony', 'Recruitment@corp.com', '800-329-9977')

SET IDENTITY_INSERT [Recruitment].[Jobs] ON
INSERT Recruitment.Jobs (
    JobID, DepartmentID, Title, Ranking, Type, BaseSalary, StartDate, SlotsRemained
) VALUES
(12355, 390, 'Software Engineer', 'I', 'Full-time', 80000, dbo.fnGetRandomDate(), 1)
SET IDENTITY_INSERT [Recruitment].[Jobs] OFF

--SET IDENTITY_INSERT [Recruitment].[Candidates] ON
INSERT Recruitment.Candidates (
    CandidateID, FirstName, LastName, Email, Phone, ShortProfile
) VALUES
(749303, 'Davison', 'Miles', 'DavMi@gmail.com', '315-882-0365', 'Strong Candidate')
--SET IDENTITY_INSERT [Recruitment].[Candidates] OFF

SET IDENTITY_INSERT [Recruitment].[Documents] ON
INSERT Recruitment.Documents (
    DocumentID, CandidateID, CVs, ReferenceLetter, CoverLetter
) VALUES
(3384, 749303, 'www.goodcompany/humanresources/38428gq', 'www.goodcompany/humanresources/38411nu', 'www.goodcompany/humanresources/55428qq')
SET IDENTITY_INSERT [Recruitment].[Documents] OFF

SET IDENTITY_INSERT [Recruitment].[Applications] ON
INSERT Recruitment.Applications (
    ApplicationID, CandidateID, JobID, Status
) VALUES
(13765338, 749303, 12355, 'Under Interview')
SET IDENTITY_INSERT [Recruitment].[Applications] OFF

SET IDENTITY_INSERT [Recruitment].[Interviewers] ON
INSERT Recruitment.Interviewers (
    InterviewerID, FirstName, LastName, Email, Phone, Title, DepartmentID
) VALUES
(3282, 'Kevin', 'Morris', 'KevMo@gmail.com', '559-233-7193', 'Senior Project Manager', 390),
(8713, 'Gary', 'Aztek', 'GaryAztek@gamil.com', '559-115-3108', 'Senior Project Manager', 390),
(8801, 'Harley', 'Jayda', 'HarleyJayda@gmail.com', '212-889-3865', 'Project Manager', 390),
(1038, 'Griffin', 'Brian', 'GrinffinBrian@gmail.com', '213-082-1397', 'Staff Manager', 390),
(6024, 'Miseal', 'Yash', 'MisealYash@gmail.com', '310-480-0924', 'Lead Manager', 390)
SET IDENTITY_INSERT [Recruitment].[Interviewers] OFF

SET IDENTITY_INSERT [Recruitment].[Interviews] ON
INSERT Recruitment.Interviews (
    InterviewID, ApplicationID, StartTime, EndTime, Round, Result, Type
) VALUES
(48292, 13765338, '2022-07-17 02:00:00', '2022-07-17 03:00:00', 1, 'Pending start', 'Online')
SET IDENTITY_INSERT [Recruitment].[Interviews] OFF

--SET IDENTITY_INSERT [Recruitment].[InterviewersGroup] OFF
INSERT Recruitment.InterviewersGroup (
	InterviewID, TestID, ChiefInterviewer, ViceInterviewer, InterviewerMember1, InterviewerMember2, InterviewerMember3
) VALUES
(48292, NULL, 3282, 8713, NULL, NULL, NULL)
--SET IDENTITY_INSERT [Recruitment].[InterviewersGroup] ON


SET IDENTITY_INSERT [Recruitment].[Tests] ON
INSERT Recruitment.Tests (
    TestID, ApplicationID, StartTime, EndTime, Type, Round, Answers, Grade
) VALUES
(38294233, 13765338, '2022-07-10 03:00:00', '2022-07-10 04:00:00', 'Online', 1, 'www.goodcompany/humanresources/38411313nxad', 'Passed'),
(38294234, 13765338, '2022-07-16 03:00:00', '2022-07-16 04:00:00', 'Online', 2, 'www.goodcompany/humanresources/48031313vpqu', 'Failed')
SET IDENTITY_INSERT [Recruitment].[Tests] OFF

SET IDENTITY_INSERT [Recruitment].[Evaluations] ON
INSERT Recruitment.Evaluations(
    EvaluationID, ApplicationID, Notes, Result
) VALUES
(38317920, 13765338, 'Good', 'Passed')
SET IDENTITY_INSERT [Recruitment].[Evaluations] OFF

INSERT Recruitment.Reimbursements (
    ReimbursementID, ApplicationID, Required, Status, AmountApproved, Expense, AirlineReservationDetail, HotelReservationDetail, CarRentalDetail
) VALUES
(24898, 13765338, 1, 'Processing', 0, 3000, 'www.goodcompany/humanresources/48479313FGNI', 'www.goodcompany/humanresources/48479313QQNV', 'www.goodcompany/humanresources/48479313OVPJ')

INSERT Recruitment.Onboardings (
    OnboardingID, ApplicationID, SpecialistID, BackgroundCheck, WorkingDate, AttendingDate, Status
) VALUES
(938492, 13765338, 482803, 1, '2022-08-10 12:00:00', '2022-08-05 12:00:00', 'Onboard')
GO

-- Triggers
CREATE TRIGGER tgCreateInterview 
	ON Recruitment.Interviews AFTER INSERT
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
	ON Recruitment.Candidates AFTER INSERT
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
	ON Recruitment.Applications AFTER INSERT
AS 
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @ApplicationID VARCHAR(50) = CONVERT(VARCHAR, (SELECT ApplicationID FROM INSERTED))
PRINT('New Application created, ApplicationID=' + @ApplicationID)
END
ELSE
PRINT('Application insertion failed.')
GO

CREATE TRIGGER tgCreateTest
	ON Recruitment.Tests AFTER INSERT
AS 
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @TestID VARCHAR(50) = CONVERT(VARCHAR, (SELECT TestID FROM INSERTED))
PRINT('New Test created, TestID=' + @TestID)
END
ELSE
PRINT('Test insertion failed.')
GO

CREATE TRIGGER tgCreateEvaluation
	ON Recruitment.Evaluations AFTER INSERT
AS
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @EvaluationID VARCHAR(50) = CONVERT(VARCHAR, (SELECT EvaluationID FROM INSERTED))
PRINT('New Evaluation created, EvaluationID=' + @EvaluationID)
END
ELSE
PRINT('Evaluation insertion failed.')
GO

CREATE TRIGGER tgCreateReimbursement
	ON Recruitment.Reimbursements AFTER INSERT
AS
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @ReimbursementID VARCHAR(50) = CONVERT(VARCHAR, (SELECT ReimbursementID FROM INSERTED))
PRINT('New Reimbursement created, ReimbursementID=' + @ReimbursementID)
END
ELSE
PRINT('Reimbursement insertion failed.')
GO

CREATE TRIGGER tgCreateOnboarding
	ON Recruitment.Onboardings AFTER INSERT
AS
IF EXISTS(SELECT * FROM INSERTED)
BEGIN
DECLARE @OnboardingID VARCHAR(50) = CONVERT(VARCHAR, (SELECT OnboardingID FROM INSERTED))
PRINT('New Onboarding created, OnboardingID=' + @OnboardingID)
END
ELSE
PRINT('Onboarding insertion failed.')
GO
