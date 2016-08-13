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
package org.oddgen.bitemp.sqldev.templates

import com.jcabi.aspects.Loggable
import org.oddgen.bitemp.sqldev.model.generator.GeneratorModelTools
import org.oddgen.bitemp.sqldev.model.generator.Table
import org.oddgen.sqldev.LoggableConstants

@Loggable(LoggableConstants.DEBUG)
class RemoveTemporalValidity {
	private extension GeneratorModelTools generatorModelTools = new GeneratorModelTools

	def compile(Table table) '''
		«IF table.exists»
			«FOR period : table.temporalValidityPeriods»
				--
				-- Remove period «period.periodname» («period.periodstart», «period.periodend») from «table.tableName»
				--
				ALTER TABLE «table.tableName.toLowerCase» DROP (PERIOD FOR «period.periodname.toLowerCase»);
			«ENDFOR»
		«ENDIF»
	'''
}
