BeginPackage["JosephBrennan`StravaLink`"];

AuthorizeStravaApplication;
GenerateStravaAccessToken;
RefreshStravaAccessToken;

Begin["`Setup`Private`"];


AuthorizeStravaApplication[redirectURI_: "http://localhost", scope_: "read_all,activity:read_all,profile:read_all"] :=
SystemOpen[
	URLBuild[
		"https://www.strava.com/oauth/authorize",
		{
			"client_id" -> SystemCredential["Strava-Client-ID"],
			"response_type" -> "code",
			"redirect_uri" -> redirectURI,
			"approval_prompt" -> "force",
			"scope" -> scope
		}
	]
];

GenerateStravaAccessToken[] :=
With[
	{
		response = 
		URLExecute[
			HTTPRequest[
				"https://www.strava.com/api/v3/oauth/token",
				<|
					"Method" -> "POST",
					"Body" -> <|
						"client_id" -> SystemCredential["Strava-Client-ID"],
						"client_secret" -> SystemCredential["Strava-Client-Secret"],
						"code" -> SystemCredential["Strava-Authorization-Code"],
						"grant_type" -> "authorization_code"
					|>
				|>
			],
			"RawJSON"
		]
	},
	Echo[response];
	Enclose[
		ConfirmAssert[
			KeyExistsQ[response, "access_token"],
			"Error: Access token not found in response!"
		];
		SystemCredential["Strava-Access-Token"] = response["access_token"];
		Return["SystemCredential[\"Strava-Access-Token\"] has been set!"]
	]
];


RefreshStravaAccessToken[] :=
With[
	{
		response =
		URLExecute[
		HTTPRequest[
			"https://www.strava.com/api/v3/oauth/token",
			<|
				"Method" -> "POST",
				"Body" -> <|
					"client_id" -> SystemCredential["Strava-Client-ID"],
					"client_secret" -> SystemCredential["Strava-Client-Secret"],
					"refresh_token" -> SystemCredential["Strava-Refresh-Token"],
					"grant_type" -> "refresh_token"
				|>
			|>
		],
		"RawJSON"
	]
	},
	SystemCredential["Strava-Access-Token"] = response["access_token"];
	Return["SystemCredential[\"Strava-Access-Token\"] has been updated!"]
];

End[];
EndPackage[];