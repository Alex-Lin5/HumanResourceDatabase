USE HumanResource
GO

DECLARE @TheCandidateID INT
DECLARE @TheApplicationID INT
-- First Candidate successfully get offer through 3 reviews including 3 tests and 2 interviews, which only final review is on-site type. He passed all the tests and interviews, then received an offer. After negotiating, offer is accepted.
BEGIN TRAN Candidate1AcceptedJob
	-- Create first candidate profile
	EXEC spCreateCandidate @FirstName='Bronco', @LastName='Lease', @Email='BroncoLea@gmail.com', @Phone='214-483-0048', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
	PRINT('First candidate application starts.')
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	-- Start second review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Review', @AssignTest=1, @AssignInterview=1

	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Start third review process
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Third Review', @Type='Onsite', @AssignTest=1, @AssignInterview=1 
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Job offered, candidate negotiated then accepted
	EXEC spUpdateApplication @Status='Offered'
	EXEC spUpdateApplication @Status='Negotiating', @Salary=60000
	EXEC spUpdateApplication @Status='Accepted'
COMMIT;

-- Second candidate first applies job and was rejected in first review. His second application is rejected in second review and complaint about the interview process, which solved as a grant of new interview, and rejected again in third review.
BEGIN TRAN Candidate2Complaint
	-- Create second candidate profile
	EXEC spCreateCandidate @FirstName='Paris', @LastName='Gordan', @Email='ParisGordan@gmail.com', @Phone='559-481-0038', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
	PRINT('Second candidate application starts.')
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
	-- Candidate makes a complaint
	EXEC spUpdateApplication @Status='Waiting'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Investegated as Pass'
	EXEC spUpdateApplication @Status='Third Review', @AssignInterview=1, @Type='Onsite'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Failed'
	EXEC spUpdateApplication @Status='Rejected'

	-- Start third application
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	EXEC spUpdateApplication @Status='Rejected'
COMMIT;

-- Third candidate is reviewed for 2 times and fulfill the recruitment requirement, but put into waiting list because of no job positions remaining
BEGIN TRAN Candidate3WaitedList
	-- Create third candidate profile
	EXEC spCreateCandidate @FirstName='Hallie', @LastName='Alexis', @Email='HallieAlexis@gmail.com', @Phone='559-378-1834', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
	PRINT('Third candidate application starts.')
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1, @AssignInterview=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Start second review
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Review', @AssignTest=0, @AssignInterview=1
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Job offered but do not have more slots so put candidate in another list
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Offered'
COMMIT;

-- Forth candidate has similar review process to candidate 3 which has 2 reviews and get offered, but candidate reject the offer this time
BEGIN TRAN Candidate4DeclinedJob
	-- Create third candidate profile
	EXEC spCreateCandidate @FirstName='Adam', @LastName='Nashalie', @Email='AdamNashalie@gmail.com', @Phone='916-338-1134', @CandidateID=@TheCandidateID OUTPUT
	EXEC spCreateDocument @CandidateID=@TheCandidateID
	-- Start first application
	PRINT('Forth candidate application starts.')
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
	-- Start first review
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='First Review', @AssignTest=1, @AssignInterview=1
	EXEC spUpdateTest @ApplicationID=@TheApplicationID, @Grade='Passed'
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	-- Start second review
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Review', @AssignTest=0, @AssignInterview=1
	EXEC spUpdateInterview @ApplicationID=@TheApplicationID, @Result='Passed'
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Offered'
	EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Declined'
COMMIT;
--PRINT('TheApplicationID=' + CONVERT(VARCHAR, @TheApplicationID))
--PRINT('EMPTY LINE');
