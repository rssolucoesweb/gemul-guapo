<!-- base css -->
<link rel="stylesheet" media="screen, print" href="css/vendors.bundle.css">
<link rel="stylesheet" media="screen, print" href="css/app.bundle.css">
<%
if session("css_layout_novo")="" then
	session("css_layout_novo")="cust-theme-4.css"
end if
%>
<link id="myskin" rel="stylesheet" media="screen, print" href="css/themes/<%=session("css_layout_novo")%>">
