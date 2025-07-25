// assets/js/header.js
// Custom script to dynamically load and build the header navbar using data from HeaderServlet.

document.addEventListener('DOMContentLoaded', function() {
    fetch(contextPath + '/header-data')
        .then(response => response.json())
        .then(data => {
            // Update logo href
            const logoLink = document.querySelector('.logo a');
            if (logoLink) {
                logoLink.href = data.homeUrl;
            }

            // Build navigation menu
            const navigation = document.getElementById('navigation');
            if (navigation) {
                navigation.innerHTML = '';
                const items = data.items;

                // Find submenu items
                const myProfile = items.find(item => item.itemName === 'My Profile');
                const changePassword = items.find(item => item.itemName === 'Change Password');

                // Build top-level items
                items.forEach(item => {
                    if (item.itemName !== 'My Profile' && item.itemName !== 'Change Password') {
                        const li = document.createElement('li');
                        const a = document.createElement('a');
                        a.href = item.itemUrl ? contextPath + '/' + item.itemUrl : '#';
                        a.textContent = item.itemName;
                        li.appendChild(a);

                        // Add submenu for 'Account'
                        if (item.itemName === 'Account') {
                            const subUl = document.createElement('ul');
                            subUl.className = 'submenu';

                            if (myProfile) {
                                const subLi = document.createElement('li');
                                const subA = document.createElement('a');
                                subA.href = contextPath + '/' + myProfile.itemUrl;
                                subA.textContent = myProfile.itemName;
                                subLi.appendChild(subA);
                                subUl.appendChild(subLi);
                            }

                            if (changePassword) {
                                const subLi = document.createElement('li');
                                const subA = document.createElement('a');
                                subA.href = contextPath + '/' + changePassword.itemUrl;
                                subA.textContent = changePassword.itemName;
                                subLi.appendChild(subA);
                                subUl.appendChild(subLi);
                            }

                            li.appendChild(subUl);
                        }

                        navigation.appendChild(li);
                    }
                });
            }

            // Build header buttons (login/register or logout)
            const headerBtnDiv = document.querySelector('.header-right-btn');
            if (headerBtnDiv) {
                headerBtnDiv.innerHTML = '';
                if (data.isLoggedIn) {
                    const logoutA = document.createElement('a');
                    logoutA.href = contextPath + '/logout';
                    logoutA.className = 'btn header-btn';
                    logoutA.textContent = 'Logout';
                    headerBtnDiv.appendChild(logoutA);
                } else {
                    const loginA = document.createElement('a');
                    loginA.href = contextPath + '/login.jsp';
                    loginA.className = 'btn header-btn';
                    loginA.textContent = 'Login';
                    headerBtnDiv.appendChild(loginA);

                    const registerA = document.createElement('a');
                    registerA.href = contextPath + '/register.jsp';
                    registerA.className = 'btn header-btn';
                    registerA.textContent = 'Register';
                    headerBtnDiv.appendChild(registerA);
                }
            }
        })
        .catch(error => console.error('Error fetching header data:', error));
});