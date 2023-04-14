CREATE TABLE Log (
                     id serial PRIMARY KEY,
                     table_name varchar(50) NOT NULL,
                     action varchar(10) NOT NULL,
                     changed_at timestamp NOT NULL
);

CREATE OR REPLACE FUNCTION log_changes()
    RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Insert a new row into the log table when an insert occurs
        INSERT INTO Log (table_name, action, changed_at)
        VALUES (TG_TABLE_NAME, 'INSERT', NOW());
    ELSIF TG_OP = 'UPDATE' THEN
        -- Insert a new row into the log table when an update occurs
        INSERT INTO Log (table_name, action, changed_at)
        VALUES (TG_TABLE_NAME, 'UPDATE', NOW());
    ELSIF TG_OP = 'DELETE' THEN
        -- Insert a new row into the log table when a delete occurs
        INSERT INTO Log (table_name, action, changed_at)
        VALUES (TG_TABLE_NAME, 'DELETE', NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_trigger
    AFTER INSERT OR UPDATE OR DELETE ON Product
    FOR EACH ROW EXECUTE FUNCTION log_changes();

CREATE TRIGGER pc_trigger
    AFTER INSERT OR UPDATE OR DELETE ON PC
    FOR EACH ROW EXECUTE FUNCTION log_changes();

CREATE TRIGGER laptop_trigger
    AFTER INSERT OR UPDATE OR DELETE ON Laptop
    FOR EACH ROW EXECUTE FUNCTION log_changes();

CREATE TRIGGER printer_trigger
    AFTER INSERT OR UPDATE OR DELETE ON Printer
    FOR EACH ROW EXECUTE FUNCTION log_changes();
