BeginPackage["JosephBrennan`StravaLink`"];
StravaAthleteData;
StravaAthleteStats;

Begin["`Private`"];


StravaAthleteData[] := 
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/athlete",
		<|
			"Headers" ->
			<|
				"Authorization" ->  "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];

StravaAthleteStats[athleteID_Integer] := 
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/athletes/" <> ToString[athleteID] <> "/stats",
		<|
			"Headers" ->
			<|
				"Authorization" ->  "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];

End[];
EndPackage[];