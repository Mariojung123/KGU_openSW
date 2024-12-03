// 모달 닫기 함수
function closeModal() {
    document.getElementById('myModal').style.display = "none"; // 모달 숨기기
}

// 모달 외부 클릭 시 모달 닫기
window.onclick = function(event) {
    const modal = document.getElementById('myModal');
    if (event.target === modal) {
        closeModal();
    }
};

// 모달 닫기 버튼 클릭 시 모달 닫기
document.getElementById('closeModal').onclick = closeModal;

// 리뷰 작성 폼 보이기/숨기기
function toggleReviewForm() {
    var form = document.getElementById('reviewForm');
    // 세션에서 가져온 사용자 정보 (null일 수 있음)
    var userId = '<%= session.getAttribute("loggedInUser") != null ? session.getAttribute("loggedInUser") : "" %>';
    console.log(userId);

    // 세션 정보가 없으면 로그인 페이지로 리다이렉트
    if (!userId) {
        alert("로그인 후 리뷰를 작성할 수 있습니다.");
        window.location.href = "login.jsp"; // 로그인 페이지로 리다이렉트
        return;
    }

    // 리뷰 폼 보이기/숨기기
    if (form.style.display === "none" || form.style.display === "") {
        form.style.display = "block";
    } else {
        form.style.display = "none";
    }
}

