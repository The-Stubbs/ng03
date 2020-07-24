# -*- coding: utf-8 -*-



################################################################################
def db_rows(cursor, query):
    cursor.execute(query)
    columns = [col[0] for col in cursor.description]
    return [dict(zip(columns, row)) for row in cursor.fetchall()]
#-------------------------------------------------------------------------------
def db_row(cursor, query):
    rows = db_rows(cursor, query)
    if rows: return rows[0]
    else: return None
#-------------------------------------------------------------------------------
def db_result(cursor, query):
    cursor.execute(query)
    return cursor.fetchone()[0]
#-------------------------------------------------------------------------------
def db_execute(cursor, query):
    cursor.execute(query)
################################################################################



################################################################################
def sql_str(text):
	ret = text.replace('\\', '\\\\') 
	ret = ret.replace('\'', '\'\'')
	ret = '\'' + ret + '\''
	return ret
#-------------------------------------------------------------------------------
def sql_value(val):
	if not val or val == '': return 'Null'
	else: return val
################################################################################



################################################################################
def get_int(value):
    if not value: return 0
    elif str(value) == '': return 0
    try: return int(value)
    except ValueError: return 0
################################################################################
