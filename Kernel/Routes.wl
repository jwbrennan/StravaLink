BeginPackage["JosephBrennan`StravaLink`"];

StravaRoutes;
StravaRouteToGPX;

Begin["`Private`"];

Options[StravaRoutes] = 
{
	"Page" -> 1, 
	"MaxItemsPerPage" -> 30
};

StravaRoutes[] :=
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/athlete/routes",
		<|
			"Headers" ->
			<|
				"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];
StravaRoutes[opts : OptionsPattern[StravaRoutes]] := 
URLExecute[
	HTTPRequest[
		URLBuild[
			"https://www.strava.com/api/v3/athlete/routes",
			{
			"page" -> OptionValue["Page"],
			"per_page" -> OptionValue["MaxItemsPerPage"]
			}
		],
		<|
			"Headers" ->
			<|
				"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];
StravaRoutes[routeID_Integer] :=
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/routes/" <> ToString[routeID],
		<|
			"Headers" ->
			<|
				"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];

StravaRouteToGPX[routeID_Integer] :=
Import[
	HTTPRequest[
		"https://www.strava.com/api/v3/routes/" <> ToString[routeID] <> "/export_gpx",
		<|
			"Headers" ->
			<|
				"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"GPX"
];
StravaRouteToGPX[
	routeID_Integer, 
	elem : (Alternatives @@ $GPXImportElements)
] :=
Association[
	Import[
		HTTPRequest[
			"https://www.strava.com/api/v3/routes/" <> ToString[routeID] <> "/export_gpx",
			<|
				"Headers" ->
				<|
					"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
				|>
			|>
		],
		{"GPX", "Rules"}
	]
][elem];



End[];
EndPackage[];