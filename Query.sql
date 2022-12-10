USE HumanResource
GO
-- 1.	Candidate applies for job openings at Your Company.
DECLARE @TheApplicationID INT
BEGIN TRAN CandidateAppliesJob
    DECLARE @TheCandidateID INT
    EXEC spCreateCandidate @FirstName='Bronco', @LastName='Lease', @Email='BroncoLea@gmail.com', @Phone='214-483-0048', @CandidateID=@TheCandidateID OUTPUT
    EXEC spCreateApplication @CandidateID=@TheCandidateID, @JobId=12355, @ApplicationID=@TheApplicationID OUTPUT
    EXEC spCreateDocument @CandidateID=@TheCandidateID
COMMIT;

-- 2.	Company rejects or selects the candidate for 1st interview, which can be online or onsite.
PRINT('TheApplicationID=' + CONVERT(VARCHAR, @TheApplicationID))
PRINT('EMPTY LINE');
EXEC dbo.spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Under Interview'

-- 3.	Company rejects or selects the candidate for the following interviews till the final ‘nth’ interview.
EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Second Interview' 
EXEC spUpdateApplication @ApplicationID=@TheApplicationID, @Status='Third Interview', @Type='Onsite' 
