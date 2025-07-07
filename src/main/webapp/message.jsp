<!-- Message Notification -->
<c:if test="${not empty message}">
    <div class="alert alert-info alert-dismissible fade show" role="alert">
            ${message}
    </div>
</c:if>
