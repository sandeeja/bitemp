/*
 * Copyright 2016 Philipp Salvisberg <philipp.salvisberg@trivadis.com>
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.oddgen.bitemp.sqldev.dal

import java.sql.Connection
import java.util.ArrayList
import java.util.List
import org.oddgen.bitemp.sqldev.resources.BitempResources
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.jdbc.datasource.SingleConnectionDataSource

class SessionDao {
	private Connection conn
	private JdbcTemplate jdbcTemplate

	new(Connection conn) {
		this.conn = conn
		this.jdbcTemplate = new JdbcTemplate(new SingleConnectionDataSource(conn, true))
	}

	def boolean hasRole(String roleName) {
		if (conn.metaData.userName == "SYS") {
			return true
		} else {
			val sql = '''
				SELECT count(*)
				  FROM session_roles
				 WHERE role = ?
			'''
			val result = jdbcTemplate.queryForObject(sql, Integer, #[roleName])
			return result == 1
		}
	}

	def boolean hasPrivilege(String privilegeName) {
		if (conn.metaData.userName == "SYS") {
			return true
		} else {
			val sql = '''
				SELECT count(*)
				  FROM session_privs
				 WHERE privilege = ?
			'''
			val result = jdbcTemplate.queryForObject(sql, Integer, #[privilegeName])
			return result == 1
		}
	}

	def boolean hasExecuteRights(String objectName) {
		if (conn.metaData.userName == "SYS") {
			return true
		} else {
			val sql = '''
				SELECT count(*)
				  FROM user_tab_privs_recd
				 WHERE table_name = ?
				   AND privilege = 'EXECUTE'
			'''
			val result = jdbcTemplate.queryForObject(sql, Integer, #[objectName])
			return result == 1
		}
	}

	def getAllFlashbackArchives() {
		var List<String> result = new ArrayList<String>
		try {
			val sql = '''
				SELECT flashback_archive_name
				  FROM dba_flashback_archive
				 ORDER BY flashback_archive_name
			'''
			result = jdbcTemplate.queryForList(sql, String)
		} catch (Exception e) {
		}
		return result
	}

	def getAccessibleFlashbackArchives() {
		val result = new ArrayList<String>
		var hasDefaultFba = false
		val sqlUserFba = '''
			SELECT flashback_archive_name
			  FROM user_flashback_archive
			 ORDER BY flashback_archive_name
		'''
		val userFba = jdbcTemplate.queryForList(sqlUserFba, String)
		var List<String> dbaFba = new ArrayList<String>
		if ("FLASHBACK ARCHIVE ADMINISTER".hasPrivilege) {
			dbaFba = getAllFlashbackArchives
		}
		try {
			val sqlDbaFbaDefault = '''
				SELECT count(*)
				  FROM dba_flashback_archive
				 WHERE status = 'DEFAULT'
			'''
			hasDefaultFba = jdbcTemplate.queryForObject(sqlDbaFbaDefault, Integer) == 1
		} catch (Exception e) {
		}
		if (hasDefaultFba) {
			result.add("") // empty entry for default FBA
		}
		if (dbaFba.size > 0) {
			result.addAll(dbaFba)
		} else {
			result.addAll(userFba)
		}
		return result
	}

	def getMissingGeneratorPrerequisites() {
		val result = new ArrayList<String>
		if (conn.metaData.databaseMajorVersion < 12) {
			result.add(BitempResources.get("ERROR_ORACLE_12_REQUIRED"))
		}
		if (! "SELECT_CATALOG_ROLE".hasRole) {
			result.add(BitempResources.get("ERROR_SELECT_CATALOG_ROLE_REQUIRED"))
		}
		return result
	}

	def getMissingInstallPrerequisites() {
		val result = new ArrayList<String>
		if (! "DBMS_FLASHBACK_ARCHIVE".hasExecuteRights) {
			result.add(BitempResources.get("ERROR_DBMS_FLASHBACK_ARCHIVE_REQUIRED"))
		}
		if (! "DBMS_FLASHBACK".hasExecuteRights) {
			result.add(BitempResources.get("ERROR_DBMS_FLASHBACK_REQUIRED"))
		}
		return result

	}

}
