<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>jsTree와 Toast UI Grid 통합</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<link rel="stylesheet"
	href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
</head>
<body>

	<!-- <h3 align="center">학 생 평 가</h3> -->
	<div id="jstree"></div>
	<br/>
	<div id="grid-container"></div>


	<script>
        $(function() {
            // 트리 데이터 가져오기
            $.ajax({
                type : 'post',
                url : '/treelist.do',
                dataType : 'json',
                success : function(data) {
                    console.log(data);
                    var academy = new Array();
                    // 데이터 받아옴
                    $.each(data, function(idx, item) {
                        academy[idx] = {
                            id : item.id,
                            parent : item.parentId,
                            text : item.name
                        };
                    });
                    // 트리 생성
                    $('#jstree').jstree({
                        core : {
                            data : academy,
                            check_callback : true
                        },
                        types : {
                            'default' : {
                                'icon' : 'jstree-folder'
                            }
                        },
                        plugins : [ 'contextmenu' ]
                    }).bind('loaded.jstree', function(event, data) {
                        // 트리 로딩 완료 이벤트
                    }).bind('select_node.jstree', function(event, data) {
                        // 노드 선택 이벤트
                        console.log("Selected Node:", data.node);

                        // Toast UI Grid 생성 및 표시
                        initializeGrid(data.node.id);
                    });
                },
                error : function(xhr, status, error) {
                    console.error('AJAX 오류:', status, error);
                }
            }); // jstree 끝
            

        });

        function initializeGrid(nodeId) {
            // Grid 생성
            var grid = new tui.Grid({
                el : document.getElementById('grid-container'),
                scrollX : false,
                scrollY : false,
                columns : [ {
                    header : '번호',
                    name : 'id'
                }, {
                    header : '이름',
                    name : 'name'
                }, {
                    header : '연락처',
                    name : 'tel',
                    editor : 'text'
                }, {
                    header : '전공자 유무',
                    name : 'majorType',
                    formatter : 'listItemText',
                    editor : {
                        type : 'select',
                        options : {
                            listItems : [ {
                                text : '전공자',
                                value : '1'
                            }, {
                                text : '비전공자',
                                value : '2'
                            } ]
                        }
                    }
                }, {
                    header : '자격증',
                    name : 'certificate',
                    formatter : 'listItemText',
                    editor : {
                        type : 'checkbox',
                        options : {
                            listItems : [ {
                                text : '정보처리기사',
                                value : '1'
                            }, {
                                text : 'SQLD',
                                value : '2'
                            }, {
                                text : '빅데이터분석기사',
                                value : '3'
                            }, {
                                text : '정보처리기능사',
                                value : '4'
                            }, {
                                text : '정보처리산업기사',
                                value : '5'
                            }, {
                                text : '-',
                                value : '6'
                            } ]
                        }
                    }
                }, {
                    header : '평가',
                    name : 'grade',
                    formatter : 'listItemText',
                    editor : {
                        type : 'radio',
                        options : {
                            listItems : [ {
                                text : '★☆☆☆☆',
                                value : '1'
                            }, {
                                text : '★★☆☆☆',
                                value : '2'
                            }, {
                                text : '★★★☆☆',
                                value : '3'
                            }, {
                                text : '★★★★☆',
                                value : '4'
                            }, {
                                text : '★★★★★',
                                value : '5'
                            } ]
                        }
                    }
                } ]
            });
            
</script>            



<!-- <script>
            // Ajax를 통해 선택된 노드 정보에 해당하는 데이터 가져오기
            $.ajax({
                type : 'post',
                url : '/grid/grid03',
                data : {
                    nodeId : nodeId
                },
                dataType : 'json',
                success : function(gridData) {
                    console.log(gridData);

                    // Grid에 데이터 설정 및 레이아웃 갱신
                    grid.resetData(gridData);
                    grid.refreshLayout();
                },
                error : function(xhr, status, error) {
                    console.error('AJAX 오류:', status, error);
                }
            });
</script>  -->
            
<script>      

var gridData = [
	<c:forEach items="${studentList}" var="student" varStatus="loop">
        {
            id: '${student.stId}',
            name: '${student.stName}',
            tel: '${student.tel}',
            majorType: '${student.majorType}',
            certificate: ['${student.certificate}'],
            grade: '${student.grade}'
        }
    </c:forEach>
];

// afterChange 이벤트 핸들러
grid.on('afterChange', function(ev) {
    console.log('after change:', ev);

    var changes = ev.changes;
    var rowKey = changes[0].rowKey + 1;
    var columnName = changes[0].columnName;
    var value = changes[0].value;

    var student = {
        stId : rowKey,
        columnName : columnName,
        value : value,
    };

    console.log('student:', student);

    // 서버로 데이터 전송
    $.ajax({
        url : '/grid/grid03', // 수정된 데이터를 처리할 서버의 엔드포인트
        type : 'POST',
        contentType : 'application/json',
        data : JSON.stringify(student),
        success : function(response) {
            console.log(response);
            grid.resetData(gridData);
        },
        error : function(xhr, status, error) {
            console.error('AJAX 오류:', status, error);
        }
    });
});

           

            console.log(gridData);

            // 여기서부터는 추가 설정 및 테마 적용 등을 수행할 수 있습니다.
            tui.Grid.applyTheme('striped', {
                cell: {
                    head: {
                        background: '#eef'
                    },
                    evenRow: {
                        background: '#fee'
                    }
                }
            });


    </script>



</body>
</html>
