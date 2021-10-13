-- Disparador para restarle 1 a la cantidad al momento de insertar en factura
CREATE TRIGGER Modificar_Inventario 
AFTER INSERT ON FACTURA FOR EACH ROW 
BEGIN 
	IF (:NEW.FECHA_RETORNO IS NULL) THEN 
		UPDATE INVENTARIO SET CANTIDAD = CANTIDAD -1 WHERE INVENTARIO.TIENDA = :NEW.TIENDA AND INVENTARIO.PELICULA = :NEW.PELICULA;
	END IF;
END;

COMMIT;


-- Funcion split_part
create or replace function split_part(pString varchar2, pDelimiter varchar2, pPartNumber integer) return varchar2 deterministic is
  vStart number; 
  vEnd   number;
begin
  if pPartNumber <> 0 and pDelimiter is not null then
    vStart := instr(pDelimiter||pString||pDelimiter, pDelimiter, sign(pPartNumber), abs(pPartNumber));
    vEnd   := instr(pDelimiter||pString||pDelimiter, pDelimiter, sign(pPartNumber), abs(pPartNumber) + 1);
  end if;
  return case         
           when pDelimiter is null and abs(pPartNumber) = 1 then pString
           when pPartNumber > 0 then substr(pString, vStart, vEnd - vStart - length(pDelimiter))                       
           when pPartNumber < 0 then substr(pString, vEnd, vStart - vEnd - length(pDelimiter))          
           else null
         end;
end;