package main

const indexTmpl string = `<html>
	<head>
		<title>sample-ci-cd</title>
	</head>
	<body>
		<h1>sample-ci-cd</h1>
		<h3>The temperature in your area is {{ .Val }}</h3>
	</body>
</html>
`

const adminTmpl string = `<html>
	<head>
		<title>sample-ci-cd</title>
		<style>
			.grid-container {
				display: inline-grid;
				gap: 5px;
			}
		</style>
	</head>
	<body>
		<div class="grid-container">
			<div class="grid-item">build date: {{ .BuildInfo.Date }}</div>
			<div class="grid-item">revision: {{ .BuildInfo.GitRevision }}</div>
			<div class="grid-item">version: {{ .BuildInfo.GitVersion }}</div>
  		</div> 
		<h1>sample-ci-cd</h1>
		<h3>Hostname: {{ .Hostname }}</h3>
		<h3>Requests count since start: {{ .RequestsCount }}</h3>
	</body>
</html>
`