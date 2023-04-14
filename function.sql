create function minprice()
    returns TABLE(success boolean, message character varying)
    language plpgsql
as
$$
BEGIN
    UPDATE PC
    SET price = price * 1.05
    WHERE (price) IN (
        SELECT  MIN(price)
        FROM PC
    );

    UPDATE Laptop
    SET price = price * 1.05
    WHERE (price) IN (
        SELECT MIN(price)
        FROM Laptop
        GROUP BY code
    );

    UPDATE Printer
    SET price = price * 1.05
    WHERE (price) IN (
        SELECT  MIN(price)
        FROM Printer
        GROUP BY code
    );
    success := TRUE;
    message := 'Price of  min price  5% .';

    RETURN success and message;
EXCEPTION
    WHEN OTHERS THEN
        success := FALSE;
        message := 'Error  ' || SQLERRM;

        RETURN;
END;
$$;
