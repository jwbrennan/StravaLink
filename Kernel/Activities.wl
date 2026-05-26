BeginPackage["JosephBrennan`StravaLink`"];

StravaActivityData;

Begin["`Private`"];


(* To Do: Add options for pagination, max items, date before/after*)

Options[StravaActivityData] = 
{
	"Page" -> 1, 
	"MaxItemsPerPage" -> 30, 
	"Before" -> Automatic, 
	"After" -> Automatic
};

(* Without options this returns the 30 most recent activities. *)
StravaActivityData[] := 
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
StravaActivityData[opts : OptionsPattern[StravaActivityData]] := 
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

StravaActivityData[id_Integer] := 
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