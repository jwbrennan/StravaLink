BeginPackage["JosephBrennan`StravaLink`"];

StravaSegment;
StravaSegmentEfforts;

Begin["`Private`"];

StravaSegment[segmentID_Integer] :=
URLExecute[
	HTTPRequest[
		"https://www.strava.com/api/v3/segments/" <> ToString[segmentID],
		<|
			"Headers" ->
			<|
				"Authorization" -> "Bearer " <> SystemCredential["Strava-Access-Token"]
			|>
		|>
	],
	"RawJSON"
];


Options[StravaSegmentEfforts] = 
{
	"StartDate" -> Automatic, 
	"EndDate" -> Automatic,
	"MaxItems" -> 30
};
StravaSegmentEfforts[segmentID_Integer, opts : OptionsPattern[StravaSegmentEfforts]] :=
With[
	{
		startDate = 
		Replace[
			OptionValue["StartDate"], 
			{
				Automatic -> "",
				_DateObject :> DateString[DateObject[OptionValue["StartDate"]], "ISODateTime"]
			}
		],
		endDate = 
		Replace[
			OptionValue["EndDate"], 
			{
				Automatic -> "",
				_DateObject :> DateString[DateObject[OptionValue["EndDate"]], "ISODateTime"]
			}
		]
	},
	URLExecute[
		HTTPRequest[
			URLBuild[
				"https://www.strava.com/api/v3/segment_efforts/?segment_id=" <> ToString[segmentID],
				{
					"start_date_local" -> startDate,
					"end_date_local" -> endDate,
					"per_page" -> OptionValue["MaxItems"]
				}
			],
			<|
				"Headers" ->
				<|
					"Authorization" ->  "Bearer " <> SystemCredential["Strava-Access-Token"]
				|>
			|>
		],
		"RawJSON"
	]
];


End[];
EndPackage[];