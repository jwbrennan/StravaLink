BeginPackage["JosephBrennan`StravaLink`"];
RetrieveStravaAthleteData;

Begin["`Athlete`Private`"];


RetrieveStravaAthleteData[] := 
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

End[];
EndPackage[];