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
			"Private.wl",
			"Setup.wl", 
			"Athlete.wl", 
			"Activities.wl",
			"Routes.wl",
			"Segments.wl"
		}
	]
];
