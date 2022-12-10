USE HumanResource
GO

DECLARE @TheCandidateID INT
DECLARE @TheApplicationID INT
-- First Candidate successfully get offer through 3 reviews including 3 tests and 2 interviews, which only final review is on-site type
BEGIN TRAN Candidate1OfferedJob
	-- Create first candidate profile
	EXEC spCreateCandidate @FirstName='Bronco', @LastName='Lease', @Email='BroncoLea@gmail.com', @Phone='214-483-0048', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	--EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Start second review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Review', @AssignTest=1, @AssignInterview=1

	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Third Review', @Type='Onsite', @AssignTest=1, @AssignInterview=1 
COMMIT;

BEGIN TRAN Candidate2Rejected
	-- Create second candidate profile
	EXEC spCreateCandidate @FirstName='Paris', @LastName='Gordan', @Email='ParisGordan@gmail.com', @Phone='559-481-0038', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Failed'
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Rejected'

	-- Start second application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	-- Start second review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Review', @AssignTest=1, @AssignInterview=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Failed'
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Rejected'

	-- Start third application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
COMMIT;

BEGIN TRAN Candidate3WaitedList
	-- Create third candidate profile
	EXEC spCreateCandidate @FirstName='Hallie', @LastName='Alexis', @Email='HallieAlexis@gmail.com', @Phone='559-378-1834', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
COMMIT;
--PRINT('TheApplicationID=' + CONVERT(VARCHAR, @TheApplicationID))
--PRINT('EMPTY LINE');
