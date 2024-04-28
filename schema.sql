-- Represent the location of clinics
CREATE TABLE "locations" (
    "id" INTEGER,
    "street_address" TEXT,
    "City" TEXT NOT NULL,
    "State" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

-- Represent dentist of the Clinic with their location
CREATE TABLE "dentists" (
    "id" INTEGER,
    "dentist_name" TEXT NOT NULL,
    "designation" TEXT NOT NULL DEFAULT "junior",
    "location_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES "locations"("id")
);

-- Represent patients of the clinic with their location
CREATE TABLE "patients" (
    "id" INTEGER,
    "patient_name" TEXT NOT NULL,
    "age" INTEGER,
    "location_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("location_id") REFERENCES "locations"("id")
);

-- Represent appointments between patients and dentists and their location
CREATE TABLE "appointments" (
    "id" INTEGER,
    "patient_id" INTEGER NOT NULL,
    "dentist_id" INTEGER NOT NULL,
    "appointment_date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "location_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("dentist_id") REFERENCES "dentists"("id"),
    FOREIGN KEY ("patient_id") REFERENCES "patients"("id"),
    FOREIGN KEY ("location_id") REFERENCES "locations"("id")
);

-- Represent payment status of the patients
CREATE TABLE "payments" (
    "id" INTEGER,
    "patient_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    "balance_paid" NUMERIC,
    "balance_pending" NUMERIC,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("patient_id") REFERENCES "patients"("id")
);

-- Represent procedures or treatments performed during appointments
CREATE TABLE "procedures" (
    "id" INTEGER,
    "appointment_id" INTEGER NOT NULL,
    "procedure_name" TEXT NOT NULL,
    "cost" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("appointment_id") REFERENCES "appointments"("id")
);

-- Create indexes to speed common searches
CREATE INDEX "idx_locations" ON "locations" ("street_address", "City", "State");
CREATE INDEX "idx_dentists" ON "dentists" ("dentist_name");
CREATE INDEX "idx_patients" ON "patients" ("patient_name");
CREATE INDEX "idx_appointments" ON "appointments" ("patient_id", "dentist_id", "appointment_date");
CREATE INDEX "idx_payments" ON "payments" ("patient_id", "amount", "balance_paid", "balance_pending");
CREATE INDEX "idx_procedures" ON "procedures" ("appointment_id", "procedure_name");

-- Create view to see the pending payments by the patients
CREATE VIEW "payments_pending" AS
SELECT "patient_id", "balance_paid", "balance_pending" FROM "payments"
WHERE "balance_pending" IS NOT NULL;

-- Create view to see the name of patient and doctors that have appointment
CREATE VIEW "schedule" AS
SELECT "dentist_name", "patient_name", "appointment_date" FROM "appointments"
JOIN "patients" ON "patients"."id" = "appointments"."patient_id"
JOIN "dentists" ON "dentists"."id" = "appointments"."dentist_id";

-- Create a view to summarize procedures performed during appointments
CREATE VIEW "procedures_summary" AS
SELECT "appointment_id", "appointment_date", "procedure_name", "cost" FROM "appointments"
JOIN "procedures" ON "appointments"."id" = "procedures"."appointment_id";

