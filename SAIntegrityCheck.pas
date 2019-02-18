program SA_Integrity_Check;
uses md5, crt, sysutils;
const VERSION = '1.3';
const AUTOR = 'Markski';

type
	bf = record
		hash : string;
		ruta : string;
		priod: string[2];
	end;

function mensaje (msj: string; leng: integer): String;
begin
	case msj of
		'advertencia': if ( leng = 1 ) then mensaje := 'You should be running this executable in your GTA-SA folder, which you are not doing. Enter 1 to continue, 0 to exit.' else mensaje := 'Deberias estar ejecutando este programa en tu carpeta de GTA-SA, cosa que pareces no estar haciendo. Ingresa 1 para continuar, 0 para salir.';
		'cancelado': if ( leng = 1 ) then mensaje := 'The program execution has been cancelled, no check has been done.' else mensaje := 'Se ha cancelado la ejecucion del programa y no se ha realizado ningun chequeo';
		'visual': if ( leng = 1 ) then mensaje := 'Enter 1 to check essential files that could mean cheats or other unexpected effects. Press 2 to run a more complete procedure that checks files that modify visual aspects.' else mensaje := 'Ingrese 1 para hacer un chequeo de los archivos esenciales, que podrian significar cheats u otros cambios en el juego. Ingrese 2 para hacer un chequeo mas completo que incluye archivos visuales.';
		'chequeando': if ( leng = 1 ) then mensaje := 'Executing integrity check. This can take quite a while depending on your specs.' else mensaje := 'Ejecutando chequeo de integridad. Esto puede tardar varios minutos dependiendo de tus especificaciones.';
		'inconsistencia': if ( leng = 1 ) then mensaje := 'INCONSISTENCY FOUND IN: ' else mensaje := 'INCONSISTENCIA ENCONTRADA EN: ';
		'finalizado': if ( leng = 1 ) then mensaje := 'Check finished.' else mensaje := 'Chequeo finalizado.';
		'mal': if ( leng = 1 ) then mensaje := ' inconsistency found. A report is available in the file IntegrityReport.txt' else mensaje := ' inconsistencia(s) encontrada(s). Un reporte esta disponible en IntegrityReport.txt';
		'nada': if ( leng = 1 ) then mensaje := 'No modified files were found, your GTA:SA install is in perfect stock state.' else mensaje := 'No se han encontrado archivos modificados. Tu instalacion de GTA:SA esta en perfecto estado.';
		'mensajeArchivo': if ( leng = 1 ) then mensaje := 'The inconsistencies shown above could mean modified gameplay experience and some of the changes could potentially be considered cheats. Please check FileReferences.txt for information.' else mensaje := 'Las inconsistencias listadas arribas pueden significar una experiencia de juego modificado al punto de hasta llegar a ser considerado cheats en muchos servidores. Se recomienda encarecidamente que leas FileReferences.txt';
		'salir': if ( leng = 1 ) then mensaje := 'You may now close the program. Press ENTER to exit. Ver. '+VERSION+' by '+AUTOR else mensaje := 'Usted puede ahora cerrar el programa. Presione INTRO para salir. Ver. '+VERSION+' por '+AUTOR;
		else 
			mensaje := 'Error loading languages / Error al cargar los lenguajes'
	end;
end;

procedure chequearArchivo (lenguaje: integer; var err: integer; buffer: bf; var a: text; var db: text);
var
	hasheo: String;
	auxiliar: String;
begin
	hasheo := MD5Print(MD5File(buffer.ruta));
	if hasheo <> buffer.hash then begin
		err := err + 1;
		writeln(mensaje('inconsistencia', lenguaje), buffer.ruta);
		auxiliar := 'Archivo/File: ' + buffer.ruta + ' | MD5 original: ' + buffer.hash + ' ; MD5 encontrado/found: ' + hasheo;
		writeln(a, auxiliar);
	end;
end;


var
	i: Integer;
	lenguaje: Integer;
	err: Integer;
	arch: text;
	db: text;
	buffer: bf;
	StringInput: string;
	ChequearGTAsa: string;
begin
	err := 0;
	writeln('Choose language / Elija su lenguaje');
	writeln('1 - English - Ingles');
	writeln('2 - Spanish - Castellano');
	readln(lenguaje);
	clrscr;
	ChequearGTAsa := MD5Print(MD5File('gta_sa.exe'));
	// Check for empty file hash
	if ChequearGTAsa = 'd41d8cd98f00b204e9800998ecf8427e' then begin
		writeln (mensaje('advertencia', lenguaje));
		readln(i);
	end else i := 1;
	if i = 1 then begin
		Assign(db, 'database.sicdb');
		Reset(db);
		Assign(arch, 'IntegrityReport.txt');
		Rewrite(arch);
		writeln (mensaje('visual', lenguaje));
		readln(i);
		clrscr;
		writeln (mensaje('chequeando', lenguaje));
		while not EOF(db) do begin
			readln(db, buffer.hash);
			readln(db, buffer.ruta);
			readln(db, buffer.priod);
			if (buffer.priod = '0') then begin
			chequearArchivo(lenguaje, err, buffer, arch, db);
			end else if (buffer.priod = '1') AND (i = 2) then chequearArchivo(lenguaje, err, buffer, arch, db);
		end;
		writeln (mensaje('finalizado', lenguaje));
		if err > 0 then begin
			writeln(err, mensaje('mal', lenguaje));
			writeln(arch, mensaje('mensajeArchivo', lenguaje))
		end else begin
			writeln(mensaje('nada', lenguaje));
			write(arch, 'No se encontraron inconsistencias. / No inconsistencies found.');
		end;
		Close(arch);
		Close(db);
	end else begin
		writeln (mensaje('cancelado', lenguaje));
	end;
	writeln (mensaje('salir', lenguaje));
	readln(StringInput);
	writeln(StringInput);
end.
