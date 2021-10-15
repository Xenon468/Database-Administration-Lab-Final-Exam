-- 1
-- Tidak ada UI untuk membuat Job dikarenakan saat inisialisasi untuk 'SQL Server Agent'
-- terjadi kegagalan.

-- 2 
CREATE PROCEDURE [Insert new Phone] (	
	@phoneId CHAR(5),
	@phoneName VARCHAR(20),
	@phonePrice MONEY,
	@phoneCreation DATE,
	@phoneColor VARCHAR(15)
)
AS
	IF DATALENGTH(@phoneId) != 5
		PRINT 'phone Id length must be 5'
	ELSE IF @phonePrice < 1000000
		PRINT 'phone price must be more than 1000000'
	ELSE
		INSERT INTO jphone VALUES (
			@phoneId,
			@phoneName,
			@phonePrice,
			@phoneCreation,
			@phoneColor
		)
BEGIN TRAN
EXECUTE [Insert new Phone] 'JP0106', 'JPhone XX', 20000000, '2000-10-10', 'White'
ROLLBACK

DROP PROCEDURE [Insert new Phone]

SELECT *
FROM jphone

-- 3
GO
CREATE PROCEDURE [View My Average Total Transaction] @staffId CHAR(5)
AS
	PRINT	'My Average Total Transaction'
	PRINT	'My Staff Id: ' + @staffId
	PRINT	'----------------------------'
	DECLARE averageCursor CURSOR
	FOR
		SELECT		jphone.phoneId, AVG(jphone.phonePrice)
		FROM		staff
		JOIN		headerTransaction ON headerTransaction.staffId = staff.staffId
		JOIN		detailTransaction ON detailTransaction.transactionId = headerTransaction.transactionId
		JOIN		jphone ON jphone.phoneId = detailTransaction.phoneId
		WHERE		staff.staffId = @staffId AND jphone.phoneId = detailTransaction.phoneId
		GROUP BY	jphone.phoneId

	OPEN averageCursor
	DECLARE @phoneId CHAR(5)
	DECLARE @avgPrice VARCHAR(255)

	FETCH NEXT FROM averageCursor
	INTO @phoneId, @avgPrice

	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT	@phoneId + ' > Rp. ' + @avgPrice
		FETCH NEXT FROM averageCursor
		INTO @phoneId, @avgPrice
	END
	CLOSE averageCursor
	PRINT	'----------------------------'
	DEALLOCATE averageCursor

BEGIN TRAN
EXECUTE [View My Average Total Transaction] 'ST003'
ROLLBACK

DROP PROCEDURE [View My Average Total Transaction]

-- 4 
GO
CREATE TRIGGER delete_staff_trigger ON staff
AFTER DELETE
AS
	IF NOT EXISTS(
		SELECT	*
		FROM	staff
	)
		PRINT 'There is nothing to delete!'
	ELSE
		BEGIN
			DECLARE staffSearch CURSOR
			FOR
				SELECT		staffId, staffName, staff.staffGender, staff.staffNumber, staffEmail
				FROM		staff

			OPEN staffSearch
			DECLARE @staffId CHAR(5)
			DECLARE @staffName VARCHAR(20)
			DECLARE @staffGender VARCHAR(20)
			DECLARE @staffNumber VARCHAR(20)
			DECLARE @staffEmail	VARCHAR(35)

			FETCH NEXT FROM averageCursor
			INTO @staffId, @staffName, @staffGender, @staffNumber, @staffEmail

			PRINT 'STAFF FIRED'
			PRINT '-----------'
			PRINT 'StaffID: ' + @staffId
			PRINT 'StaffName: ' + @staffName
			PRINT 'StaffGender: ' + @staffGender
			PRINT 'StaffNumber: ' + @staffNumber
			PRINT 'StaffEmail: ' + @staffEmail
		END

BEGIN TRAN
DELETE FROM staff WHERE staffId = 'ST001'