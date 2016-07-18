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
package org.oddgen.bitemp.sqldev

import com.jcabi.aspects.Loggable
import javax.swing.JCheckBox
import oracle.ide.panels.DefaultTraversablePanel
import oracle.ide.panels.TraversableContext
import oracle.ide.panels.TraversalException
import oracle.javatools.ui.layout.FieldLayoutBuilder
import org.oddgen.bitemp.sqldev.model.PreferenceModel
import org.oddgen.bitemp.sqldev.resources.BitempResources
import org.oddgen.sqldev.LoggableConstants
import javax.swing.JTextField

@Loggable(LoggableConstants.DEBUG)
class PreferencePanel extends DefaultTraversablePanel {
	final JCheckBox validTimeDefaultCheckBox = new JCheckBox
	final JCheckBox transactionTimeDefaultCheckBox = new JCheckBox
	final JTextField flashbackArchiveName = new JTextField
	final JTextField validFromColName = new JTextField
	final JTextField validToColName = new JTextField
	final JTextField isDeletedColName = new JTextField
	final JTextField objectTypeSuffix = new JTextField
	final JTextField collectionTypeSuffix = new JTextField
	final JTextField latestTableSuffix = new JTextField
	final JTextField historyTableSuffix = new JTextField
	final JTextField historySequenceSuffix = new JTextField
	final JTextField historyViewSuffix = new JTextField
	final JTextField iotSuffix = new JTextField
	final JTextField apiPackageSuffix = new JTextField
	final JTextField apiHookPackageSuffix = new JTextField

	new() {
		layoutControls()
	}

	def private layoutControls() {
		val FieldLayoutBuilder builder = new FieldLayoutBuilder(this)
		builder.alignLabelsLeft = true
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_GEN_VALID_TIME_LABEL")).component(
				validTimeDefaultCheckBox))
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_GEN_TRANSACTION_TIME_LABEL")).component(
				transactionTimeDefaultCheckBox))
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_FLASHBACK_ARCHIVE_NAME_LABEL")).component(
				flashbackArchiveName))
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_VALID_FROM_COL_NAME_LABEL")).component(
				validFromColName))
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_VALID_TO_COL_NAME_LABEL")).component(
				validToColName))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_IS_DELETED_COL_NAME_LABEL")).component(
				isDeletedColName))
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_OBJECT_TYPE_SUFFIX_LABEL")).component(
				objectTypeSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_COLLECTION_TYPE_SUFFIX_LABEL")).component(
				collectionTypeSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_LATEST_TABLE_SUFFIX_LABEL")).component(
				latestTableSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_HISTORY_TABLE_SUFFIX_LABEL")).component(
				historyTableSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_HISTORY_SEQUENCE_SUFFIX_LABEL")).component(
				historySequenceSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_HISTORY_VIEW_SUFFIX_LABEL")).component(
				historyViewSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_IOT_SUFFIX_LABEL")).component(
				iotSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_API_PACKAGE_SUFFIX_LABEL")).component(
				apiPackageSuffix))						
		builder.add(
			builder.field.label.withText(BitempResources.getString("PREF_API_HOOK_PACKAGE_SUFFIX_LABEL")).component(
				apiHookPackageSuffix))						
		builder.addVerticalSpring
	}

	override onEntry(TraversableContext traversableContext) {
		var PreferenceModel info = traversableContext.userInformation
		validTimeDefaultCheckBox.selected = info.isGenValidTime
		transactionTimeDefaultCheckBox.selected = info.genTransactionTime
		flashbackArchiveName.text = info.flashbackArchiveName
		validFromColName.text = info.validFromColName
		validToColName.text = info.validToColName
		isDeletedColName.text = info.isDeletedColName
		objectTypeSuffix.text = info.objectTypeSuffix
		collectionTypeSuffix.text = info.collectionTypeSuffix
		latestTableSuffix.text = info.latestTableSuffix
		historyTableSuffix.text = info.historyTableSuffix
		historySequenceSuffix.text = info.historySequenceSuffix
		historyViewSuffix.text = info.historyViewSuffix
		iotSuffix.text = info.iotSuffix
		apiPackageSuffix.text = info.apiPackageSuffix
		apiHookPackageSuffix.text = info.apiHookPackageSuffix
		super.onEntry(traversableContext)
	}

	override onExit(TraversableContext traversableContext) throws TraversalException {
		var PreferenceModel info = traversableContext.userInformation
		info.genValidTime = validTimeDefaultCheckBox.selected
		info.genTransactionTime = transactionTimeDefaultCheckBox.selected
		info.flashbackArchiveName = flashbackArchiveName.text
		info.validFromColName = validFromColName.text
		info.validToColName = validToColName.text
		info.isDeletedColName = isDeletedColName.text
		info.objectTypeSuffix = objectTypeSuffix.text
		info.collectionTypeSuffix = collectionTypeSuffix.text
		info.latestTableSuffix = latestTableSuffix.text
		info.historyTableSuffix = historyTableSuffix.text
		info.historySequenceSuffix = historySequenceSuffix.text
		info.historyViewSuffix = historyViewSuffix.text
		info.iotSuffix = iotSuffix.text
		info.apiPackageSuffix = apiPackageSuffix.text
		info.apiHookPackageSuffix = apiHookPackageSuffix.text

		super.onExit(traversableContext)
	}

	def private static PreferenceModel getUserInformation(TraversableContext tc) {
		return PreferenceModel.getInstance(tc.propertyStorage)
	}
}
