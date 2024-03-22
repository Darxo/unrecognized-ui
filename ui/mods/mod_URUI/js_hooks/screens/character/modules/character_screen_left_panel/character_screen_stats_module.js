var modURUI_CharacterScreenStatsModule_setProgressbarValue = CharacterScreenStatsModule.prototype.setProgressbarValue;
CharacterScreenStatsModule.prototype.setProgressbarValue = function (_progressbarDiv, _data, _valueKey, _valueMaxKey, _labelKey)
{
	if (_valueKey === ProgressbarValueIdentifier.Initiative)
	{
		if (MSU.getSettingValue("mod_URUI", "DisplayBaseInitiative") === true)
		{
			if (_valueKey in _data && _data[_valueKey] !== null && _valueMaxKey in _data && _data[_valueMaxKey] !== null)
			{
				_progressbarDiv.changeProgressbarNormalWidth(_data[_valueKey], _data[_valueMaxKey]);
			}
			if (_labelKey in _data && _data[_labelKey] !== null)
			{
				_progressbarDiv.changeProgressbarLabel(_data[_labelKey]);
			}
			else
			{
				_progressbarDiv.changeProgressbarLabel('' + _data[_valueKey] + ' / ' + _data[_valueMaxKey] + '');
			}
			return;
		}
	}

	modURUI_CharacterScreenStatsModule_setProgressbarValue.call(this, _progressbarDiv, _data, _valueKey, _valueMaxKey, _labelKey);
};
