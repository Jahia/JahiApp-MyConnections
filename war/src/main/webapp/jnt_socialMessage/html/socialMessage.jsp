<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>

<c:set var="fromUser" value="${currentNode.properties['j:from'].node}"/>
<ul class="messageActionList">
   <li><a class="messageActionDelete" title="<fmt:message key='deleteMessage'/>" href="#delete" rel="${currentNode.identifier}"><span><fmt:message
        key="deleteMessage"/></span></a></li>
  <li><a class="messageActionReply" title="<fmt:message key='replyToMessage'/>" href="#divSendMessage" rel="${fromUser.name}|${fn:escapeXml(currentNode.propertiesAsString['j:subject'])}"><span><fmt:message key="replyToMessage"/></span></a></li>

</ul>
<div class='image'>
	<div class='itemImage itemImageLeft'>
    <a href="${url.base}${fromUser.path}.html"><img src="${url.currentModule}/images/friend.png"
                                                         alt="friend" border="0"/></a>
	</div>
</div>
<h5 class="messageSenderName">
    <a href="${url.base}${fromUser.path}.html"><c:out value="${jcr:userFullName(fromUser)}"/></a>
</h5><jcr:nodeProperty node="${currentNode}" name="jcr:lastModified" var="lastModified"/><span class="timestamp"><fmt:formatDate
value="${lastModified.time}" pattern="yyyy/MM/dd HH:mm"/></span>
<h5><a class="messageDetailLink" href="#socialMessageDetail" rel="${url.base}${currentNode.path}.detail.html">${fn:escapeXml(currentNode.propertiesAsString['j:subject'])}</a></h5>
<p>${fn:escapeXml(fn:substring(currentNode.propertiesAsString['j:body'], 0, 100))}...</p>

<div class='clear'></div>
