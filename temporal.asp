
<%

texto=Request.QueryString("MNcontacto")

'estas funciones teoricamente convierten el link de aemailto que supuestamente le manda el odt.js pero no sé si lo estoy obteniendo bien o las funciones
'no están andando bien 

'''''Private Sub crealink()
'''''temp = Request.QueryString["Texto"]
response.write(texto)
'''''using System;
'''''using System.Data;
'''''using System.Configuration;
'''''using System.Collections;
'''''using System.Web;
'''''using System.Web.Security;
'''''using System.Web.UI;
'''''using System.Web.UI.WebControls;
'''''using System.Web.UI.WebControls.WebParts;
'''''using System.Web.UI.HtmlControls;
'''''using System.Text.RegularExpressions;
 
'''''public partial class convert_text_to_url_and_mailto : System.Web.UI.Page
'''''{
'''''    protected void Page_Load(object sender, EventArgs e)
'''''    {
'''''        string content = temp;
 
'''''        Regex url_regex = new Regex(@"(http:\/\/([\w.]+\/?)\S*)", RegexOptions.IgnoreCase | RegexOptions.Compiled);
 
'''''        Regex email_regex = new Regex(@"([a-zA-Z_0-9.-]+\@[a-zA-Z_0-9.-]+\.\w+)", RegexOptions.IgnoreCase | RegexOptions.Compiled);
 
'''''        content = url_regex.Replace(content, "<a href=\"$1\" target=\"_blank\">$1</a>");
'''''        content = email_regex.Replace(content, "<a href=mailto:$1>$1</a>");
 
'''''        Response.Write(content);
'''''    }
'''''}
'''''end sub
%>
 