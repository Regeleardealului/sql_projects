-- I check my dataset
DESC nashville_house_prices;

-- Standardize date format

UPDATE nashville_house_prices
SET saledate = TO_DATE(saledate, 'DD-MON-YYYY');

-- Populate property adress data

UPDATE nashville_house_prices a
SET propertyaddress = NVL(propertyaddress, 
                          (SELECT MAX(b.propertyaddress)
                           FROM nashville_house_prices b
                           WHERE b.parcelid = a.parcelid AND b.uniqueid_ <> a.uniqueid_))
WHERE propertyaddress IS NULL;

-- Breaking out adress into individual columns in case of propertyaddress: adress, city

ALTER TABLE nashville_house_prices
ADD PropertySplitAddress NVARCHAR2(255);

ALTER TABLE nashville_house_prices
ADD PropertySplitCity NVARCHAR2(255);

UPDATE nashville_house_prices
SET PropertySplitAddress = SUBSTR(propertyaddress, 1, INSTR(propertyaddress, ',') - 1);

UPDATE nashville_house_prices
SET PropertySplitCity = SUBSTR(propertyaddress, INSTR(propertyaddress, ',') + 1, LENGTH(propertyaddress));

-- Breaking out adress into individual columns in case of owneradress: adress, city, state

ALTER TABLE nashville_house_prices
ADD OwnerSplitAddress NVARCHAR2(255);

ALTER TABLE nashville_house_prices
ADD OwnerSplitCity NVARCHAR2(255);

ALTER TABLE nashville_house_prices
ADD OwnerSplitSate NVARCHAR2(255);

UPDATE nashville_house_prices
SET OwnerSplitAddress = SUBSTR(owneraddress, 1, INSTR(owneradress, ',') - 1),
    OwnerSplitCity = SUBSTR(owneraddress, INSTR(owneradress, ',') + 2, INSTR(owneradress, ',', 1, 2) - INSTR(owneradress, ',') - 2),
    OwnerSplitState = SUBSTR(owneraddress, INSTR(owneradress, ',', 1, 2) + 2);
    

-- Change "Y" and "N" to "Yes" and "No" in SoldAsVacant column

UPDATE nashville_house_prices
SET soldasvacant = CASE 
                     WHEN soldasvacant = 'Y' THEN 'Yes'
                     WHEN soldasvacant = 'N' THEN 'No'
                     ELSE soldasvacant
                   END;
                   
                   
-- Remove duplicates from the dataset, by keeping only one copy of each set of duplicates.

DELETE FROM nashville_house_prices
WHERE ROWID NOT IN (
                    SELECT MIN(ROWID)
                    FROM nashville_house_prices
                    GROUP BY parcelid, propertyaddress, saleprice, saledate, legalreference
                    );

-- Delete unused columns

ALTER TABLE nashville_house_prices DROP COLUMN owneraddress;
ALTER TABLE nashville_house_prices DROP COLUMN taxdistrict;
ALTER TABLE nashville_house_prices DROP COLUMN propertyadress;



























