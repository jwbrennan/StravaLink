BeginPackage["JosephBrennan`StravaLink`"];

RetrieveStravaActivityData;

Begin["`Activities`Private`"];


(* To Do: Add options for pagination, max items, date before/after*)

Options[RetrieveStravaActivityData] = 
{
	"Page" -> 1, 
	"MaxItemsPerPage" -> 30, 
	"Before" -> Automatic, 
	"After" -> Automatic
};

(* Without options this returns the 30 most recent activities. *)
RetrieveStravaActivityData[] := 
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/athlete/activities",
		<|
			"Headers" ->
			<|
				"Authorization" ->  "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];
RetrieveStravaActivityData[opts : OptionsPattern[RetrieveStravaActivityData]] := 
With[
	{
		before = 
		Replace[
			OptionValue["Before"], 
			{
				Automatic -> "",
				_DateObject :> UnixTime[OptionValue["Before"]]
			}
		],
		after = 
		Replace[
			OptionValue["After"], 
			{
				Automatic -> "",
				_DateObject :> UnixTime[OptionValue["After"]]
			}
		]
	},
	URLExecute[
		HTTPRequest[
			URLBuild[
				"https://www.strava.com/api/v3/athlete/activities",
				{
				"page" -> OptionValue["Page"],
				"per_page" -> OptionValue["MaxItemsPerPage"],
				"before" -> before,
				"after" -> after
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
	]
];
RetrieveStravaActivityData[
	opts : OptionsPattern[RetrieveStravaActivityData] /; 
	DateObjectQ[OptionValue["Before"]] || DateObjectQ[OptionValue["After"]]
] := 
URLExecute[
	HTTPRequest[
		URLBuild[
			"https://www.strava.com/api/v3/athlete/activities",
			{
			"page" -> OptionValue["Page"],
			"per_page" -> OptionValue["MaxItemsPerPage"],
			"before" -> UnixTime[OptionValue["Before"]],
			"after" -> UnixTime[OptionValue["After"]]
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

RetrieveStravaActivityData[id_Integer] := 
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/activities/" <> ToString[id],
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