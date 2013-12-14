local rp_languages = {}
local selectedLanguage = GetConVarString("gmod_language") -- Switch language by setting gmod_language to another language

function DarkRP.addLanguage(name, tbl)
	local old = rp_languages[name] or {}
	rp_languages[name] = tbl

	-- Merge the language with the translations added by DarkRP.addPhrase
	for k,v in pairs(old) do
		if rp_languages[name][k] then continue end
		rp_languages[name][k] = v
	end
	LANGUAGE = rp_languages[name] -- backwards compatibility
end

function DarkRP.addPhrase(lang, name, phrase)
	rp_languages[lang] = rp_languages[lang]  or {}
	rp_languages[lang][name] = phrase
end

function DarkRP.getPhrase(name, ...)
	local langTable = rp_languages[selectedLanguage] or rp_languages.en

	return string.format(langTable[name] or rp_languages.en[name], ...)
end

function DarkRP.getMissingPhrases(lang)
	lang = lang or selectedLanguage
	local res = {}
	local format = "%s = \"%s\","

	for k,v in pairs(rp_languages.en) do
		if rp_languages[lang][k] then continue end
		table.insert(res, string.format(format, k, v))
	end

	return #res == 0 and "No language strings missing!" or table.concat(res, "\n")
end

local function getMissingPhrases(ply, cmd, args)
	if not args[1] then print("Please run the command with a language code e.g. darkrp_getphrases \"en\"") return end
	local lang = rp_languages[args[1]]
	if not lang then print("This language does not exist! Make sure the casing is right.")
		print("Available languages:")
		for k,v in pairs(rp_languages) do print(k) end
		return
	end

	print(DarkRP.getMissingPhrases(args[1]))
end
if CLIENT then concommand.Add("darkrp_getphrases", getMissingPhrases) end
