classdef db_misure
    % Connessione e funzioni verso il db
    
    properties (SetAccess=private, GetAccess=private)
        connection;
    end
    
    methods
%% Costruttore e distruttore
        function obj = db_misure()
            obj.connection = database('misure', 'root', 'root', ...
                                      'com.mysql.jdbc.Driver', ...
                                      'jdbc:mysql://127.0.0.1:3306/misure');
        end

        function delete(obj)
            close(obj.connection)
        end
        
%% Crea schema   
        function ret = create_schema(obj)
            file = fopen('db/db.sql');
            sql = fscanf(file, '%c');
            ret = exec(obj.connection, sql);
        end

%% Ottieni ultimo id
        function lastId = getLastId(obj, table)
           sql = ['SELECT id FROM ' table ' WHERE id = @@IDENTITY'];
           curs = exec(obj.connection, sql);
           curs = fetch(curs);
           lastId = curs.Data;
        end

%% Gestione parametri
        function parameters = getParameterList(obj)
           sql = 'SELECT * FROM parameter;';
           curs = exec(obj.connection, sql);
           curs = fetch(curs);
           parameters = curs.Data;
        end
        
        function parameterId = createParameter(obj, name, description)
           sql = ['INSERT INTO parameter ' ...
                  'VALUES(NULL,''' name, ''',''', description, ''');'];
           exec(obj.connection, sql);
           
           parameterId = getLastId('parameter');
        end
        
%% Gestione articoli
        function items = getItemList(obj)
           sql = 'SELECT * FROM item;';
           curs = exec(obj.connection, sql);
           curs = fetch(curs);
           items = curs.Data;
        end
        
        function itemId = createItem(obj, name)
           sql = ['INSERT INTO item ' ...
                  'VALUES(NULL,''' name, ''');'];
           exec(obj.connection, sql);
           
           itemId = getLastId('item');
        end
        
%% Gestione produzione
        function newProductionId = getNewProduction(obj)
            sql = 'SELECT id FROM production WHERE production_date_end = NULL ORDER BY production_date_start DESC LIMIT 1';
            curs = exec(obj.connection, sql);
            curs = fetch(curs);
            
            if curs.Data == 'No Data'
                newProductionId = 0;
            else
                newProductionId = curs.Data;
            end
        end
    end
    
end

