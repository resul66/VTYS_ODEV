CREATE TABLE "public"."hastaodadegisikligi" (
	"kayitNo" serial,
	"hastaTC" SMALLINT NOT NULL,
	"eskiOda" REAL NOT NULL,
	"yeniOda" REAL NOT NULL,
	"degisiklikTarihi" TIMESTAMP NOT NULL,
	CONSTRAINT "PK" PRIMARY KEY ("kayitNo")
);

CREATE OR REPLACE FUNCTION "odaDegisikligiTR1"()
RETURNS TRIGGER 
AS
$$
BEGIN
    IF NEW."oda_no" <> OLD."oda_no" THEN
        INSERT INTO "hastaodadegisikligi"("hastaTC", "eskiOda", "yeniOda", "degisiklikTarihi")
        VALUES(OLD."hasta_tc", OLD."oda_no", NEW."oda_no", CURRENT_TIMESTAMP::TIMESTAMP);
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "hastaOdaDegistiginde"
BEFORE UPDATE ON "hasta"
FOR EACH ROW
EXECUTE PROCEDURE "odaDegisikligiTR1"();

UPDATE "hasta"
SET "oda_no" = 15
WHERE "hasta_tc" = 123456789


 
 
 
 
 
 
 
 
 
CREATE OR REPLACE FUNCTION "kayitEkle"()
RETURNS TRIGGER 
AS
$$
BEGIN
    NEW."doktor_id" = UPPER(NEW."doktor_id"); -- büyük harfe dönüştürdükten sonra ekle
    
    IF NEW."doktor_cepTel" IS NULL THEN
            RAISE EXCEPTION 'CEP TELEFON boş olamaz';  
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE "plpgsql";

CREATE TRIGGER "kayitKontrol"
BEFORE INSERT OR UPDATE ON "doktor"  
EXECUTE PROCEDURE "kayitEkle"();







