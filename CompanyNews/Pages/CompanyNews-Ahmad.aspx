<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<WebPartPages:AllowFraming ID="AllowFraming" runat="server" />

<html>
<head>
    <title></title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.20.1/moment.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-1.9.1.min.js"></script>
    <link href="../Content/App.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" />
    
</head>
<body>
    <div class="contain">
        <div   style="font-weight:bold ; font-size: 1.5em ; r"> <i class="fa fa-newspaper-o" aria-hidden="true"></i> Latest news</div>
        <div id="listResult"></div>
    </div>




    <script>

        var hostweburl;
        var appweburl;

        // Load the required SharePoint libraries
        $(document).ready(function () {
            //Get the URI decoded URLs.
            hostweburl = decodeURIComponent(getQueryStringParameter("SPHostUrl"));
            appweburl = decodeURIComponent(getQueryStringParameter("SPAppWebUrl"));

            // resources are in URLs in the form: web_url/_layouts/15/resource
            var scriptbase = hostweburl + "/_layouts/15/";

            // Load the js files and continue to the successHandler
            $.getScript(scriptbase + "SP.RequestExecutor.js", execCrossDomainRequest);

        });

        // Function to prepare and issue the request to get SharePoint data
        function execCrossDomainRequest() {
            // executor: The RequestExecutor object Initialize the RequestExecutor with the app web URL.
            var executor = new SP.RequestExecutor(appweburl);

            // Deals with the issue the call against the app web.
            executor.executeAsync({
                url: appweburl + "/_api/SP.AppContextSite(@target)/web/lists/getbytitle('CompanyNewsList')/items?@target='" + hostweburl + "/CompanyNewsSite'&$select=Title%2CCreated%2CCategory%2CShow%2CID",
                method: "GET",
                headers: { "Accept": "application/json; odata=verbose" },
                success: successHandler,
                error: errorHandler
            }
            );
        }

        //MIN FUktion LISTA
        function successHandler(data) {
            var jsonObject = JSON.parse(data.body);
            var items = [];
            var results = jsonObject.d.results;
            items.push('<div class="object">'+"<ul>");
            
            $(results).each(function () {
                if (this.Show == 'Yes') {
                    items.push('<li class="object__comment">' + 
                   
                        " <a href=\"" + hostweburl + "/CompanyNewsSite/Lists/CompanyNewsList/DispForm.aspx?ID=" + this.ID + "\" target=\"_blank\">" + this.Title + "</a>" + '<br>' + 'Created: '+ moment(this.Created).format('YYYY-MM-DD') + '<br>' + 'Category: ' + '<span id="categ">' + this.Category +'</span>' +
                        '</li>');
                    
                }
                
            });
            
            items.push("</ul>" + ' </ div >');
            $("#listResult").html(items.join(''))

        }
       
        // Function to handle the error event. Prints the error message to the page.
        function errorHandler(data, errorCode, errorMessage) {
            document.getElementById("internal").innerText = "Could not complete cross-domain call: " + errorMessage;
        }

        // Function to retrieve a query string value.
        function getQueryStringParameter(paramToRetrieve) {
            var params =
                document.URL.split("?")[1].split("&");
            var strParams = "";
            for (var i = 0; i < params.length; i = i + 1) {
                var singleParam = params[i].split("=");
                if (singleParam[0] == paramToRetrieve)
                    return singleParam[1];
            }
        }

    </script>
    <%--app.js till app setting --%>
  <script src="../Scripts/App.js"></script>
</body>
</html>
