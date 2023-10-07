
-- INSURANCE CASE STUDY

-- QUESTION 1
-- Based on Policy Holder Country find the number of policies
-- Answer Query

SELECT 
party.Country,
COUNT(policy.PolicyID) AS NumberOfPolicies
FROM
insurance.party AS party
INNER JOIN
insurance.policy AS policy
ON party.PartyID= policy.PolicyHolderId
GROUP BY 1
ORDER BY 1;

-- QUESTION 2
-- Which Country Policy holder has created more number of claims?
-- Answer Query

SELECT 
party.country,
COUNT(DISTINCT claim.IncidentID) AS ClaimCount
FROM
insurance.claims AS claim
INNER JOIN
insurance.policy AS policy
ON claim.PolicyID= policy.PolicyID
INNER JOIN
insurance.party AS party
ON party.PartyID= policy.PolicyHolderID
GROUP BY 1
ORDER BY 2 DESC;

-- QUESTION 3
-- Find the premium of each policy
-- Answer Query

SELECT 
a.PolicyID,
SUM(b.writtenPremium) AS PremiumAmount
FROM
insurance.policy AS a
INNER JOIN
insurance.premium AS b
ON a.PolicyID= b.PolicyID
GROUP BY 1
ORDER BY 2 DESC;

-- QUESTION 4
-- Find the policy where claim amount (loss incured) paid is greater than the premium.
-- Answer Query

WITH temp AS(
SELECT 
a.PolicyID,
SUM(b.writtenPremium) AS PremiumAmount
FROM
insurance.policy AS a
INNER JOIN
insurance.premium AS b
ON a.PolicyID= b.PolicyID
GROUP BY 1),
loss AS(
SELECT 
a.PolicyID,
SUM(LossIncured) AS ClaimAmount
FROM
insurance.policy AS a
INNER JOIN
insurance.claims AS c
ON c.PolicyID = a. PolicyID
GROUP BY 1)
SELECT 
loss.PolicyID
FROM
loss
INNER JOIN
temp
ON temp.PolicyID= loss.PolicyID
WHERE ClaimAmount>PremiumAmount;

-- QUESTION 5
-- Find the policy where claim created date (col: lossdate) before the policy effective date (col: PolicyStartDate) and print policy number and holder name.
-- Answer Query

SELECT
p.PolicyID, 
p1.name
FROM
insurance.policy AS p
INNER JOIN 
insurance.claims AS c
ON p.PolicyID=c.PolicyID
INNER JOIN
insurance.party AS p1
ON p.PolicyHolderID= p1.PartyID
WHERE c.lossDate> p.PolicyStartDarte;