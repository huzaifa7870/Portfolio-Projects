SELECT * 
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing nash


ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)





----------------------------------------------------------------------------------------------

-- Populate Property Address data


SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN  PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL



UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN  PortfolioProject..NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL



----------------------------------------------------------------------------------------------

--Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
   
FROM PortfolioProject..NashvilleHousing


UPDATE  PortfolioProject..NashvilleHousing
SET PropertySplitAddress = CONVERT(nvarchar(255), PropertySplitAddress)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertySplitCity nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))






SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing



SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortfolioProject..NashvilleHousing



ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerSplitState nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


SELECT * 
FROM PortfolioProject..NashvilleHousing




----------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in 'Sold as Vacant' field


SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant
, CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
FROM PortfolioProject..NashvilleHousing




UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END




----------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	ORDER BY
	UniqueID
	) row_num
From PortfolioProject..NashvilleHousing
)
SELECT *
From RowNumCTE
--Where row_num > 1
Order by PropertyAddress




----------------------------------------------------------------------------------------------
 
-- Delete Unusual Columns

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate;



Select *
From PortfolioProject..NashvilleHousing
Order by [UniqueID ]