/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import stringUtilTest from './LocalUnit.test';
import i18nUtilTest from './I18nUtil.test';
import indexTest from './Index.test';
import entryAbilityTest from './EntryAbility.test';
import entryBackupAbilityTest from './EntryBackupAbility.test';

export default function testsuite() {
  stringUtilTest();
  i18nUtilTest();
  indexTest();
  entryAbilityTest();
  entryBackupAbilityTest();
}