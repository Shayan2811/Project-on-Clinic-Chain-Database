-- Add a new clinic location
INSERT INTO "locations" ("street_address", "City", "State")
VALUES ("1_Akron_General_Ave", "Akron", "OH");

-- Add a new dentist
INSERT INTO "dentists" ("dentist_name", "designation", "location_id")
VALUES ("Shayan_Rashid", "DMD", "1"),
("Arthur_Wales", "Orthodontist", "1");

-- Add a new patient
INSERT INTO "patients" ("patient_name", "age", "location_id")
VALUES ("David_Boston", "25", "1");

-- Add a new appointment
INSERT INTO "appointments" ("patient_id", "dentist_id", "location_id")
VALUES ("1", "1", "1");

-- Update the payment of new patient
INSERT INTO "payments" ("patient_id", "amount", "balance_paid", "balance_pending")
VALUES ("1", "850", "700", "150");

-- Add a new procedure
INSERT INTO "procedures" ("appointment_id", "procedure_name", "cost")
VALUES ("1", "extraction", "700");

-- Names of patient with pending payment
SELECT * FROM "patients"
WHERE "id" IN (
    SELECT "patient_id" FROM "payments"
    WHERE "balance_pending" IS NOT NULL
);

-- Names of dentist that were busy on 24th April, 2024
SELECT * FROM "dentists"
WHERE "id" IN (
    SELECT "dentist_id" FROM "appointments"
    WHERE "appointment_date" LIKE "2024-04-21%"
);

-- Schedule for date 24th April, 2024
SELECT * FROM "schedule"
WHERE "appointment_date" LIKE "2024-04-21%";

-- Updating the payment of David_Boston
UPDATE "payments" SET "balance_paid" = "850", "balance_pending" = "0"
WHERE "patient_id" = (
    SELECT "id" FROM "patients"
    WHERE "patient_name" = "David_Boston"
);

-- Deleting Arthur Wales from data as he is no longer part of the company
DELETE FROM "dentists"
WHERE "dentist_name" = "Arthur_Wales";

-- List the total balance paid and balance pending for each patient.
SELECT "patient_id", SUM("balance_paid") AS "total_paid", SUM("balance_pending") AS "total_pending"
FROM "payments"
GROUP BY "patient_id";

-- Find the total cost of procedures performed during each appointment
SELECT "appointment_id", SUM("cost") AS "total_cost" FROM "procedures"
GROUP BY "appointment_id";

-- Get the count of appointments for each dentist
SELECT "dentist_id", "dentist_name", COUNT(*) AS "appointment_count" FROM "appointments"
JOIN "dentists" ON "appointments"."dentist_id" = "dentists"."id"
GROUP BY "dentist_id";

-- Retrieve all procedures performed during appointments along with their costs
SELECT "procedure_name", "cost", "appointment_date" FROM "procedures"
JOIN "appointments" ON "procedures"."appointment_id" = "appointments"."id";

-- Retrieve all dentists from city Akron
SELECT "dentist_name", "designation", "street_address" FROM "dentists"
JOIN "locations" ON "dentists"."location_id" = "locations"."id"
WHERE "City" = "Akron";
