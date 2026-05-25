BeginPackage["JosephBrennan`StravaLink`"];

RetrieveStravaRoutes;
StravaRouteToGPX;

Begin["`Routes`Private`"];

Options[RetrieveStravaRoutes] = 
{
	"Page" -> 1, 
	"MaxItemsPerPage" -> 30
};

RetrieveStravaRoutes[] :=
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
RetrieveStravaRoutes[opts : OptionsPattern[RetrieveStravaRoutes]] := 
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
$GPXImportElements = 
{
	"Comments", "Data", "Graphics", "GraphicsList", "LayerNames", 
	"Metadata", "Name", "SpatialRange", "Summary", "TabularAssociation"
};
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