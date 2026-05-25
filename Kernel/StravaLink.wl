With[
	{
		kernelDir =
		FileNameJoin[
			{PacletObject["JosephBrennan/StravaLink"]["Location"], "Kernel"}
		]
	},
	Map[
		Get[FileNameJoin[{kernelDir, #}]] &,
		{
			"Setup.wl", 
			"Athlete.wl", 
			"Activities.wl",
			"Routes.wl"
		}
	]
];
