<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>jsTree and Toast UI Grid Integration</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/themes/default/style.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/grid/latest/tui-grid.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.2.1/jstree.min.js"></script>
<script src="https://uicdn.toast.com/grid/latest/tui-grid.js"></script>
</head>

<body>
<!-- jstree가 생성될 곳 -->
<div id="jstree"></div>
<br />
<!-- grid가 생성될 곳 -->
<div id="grid-container"></div>


<script>


$(function() {
	
	var grid = null; // 전역변수로 grid 선언, 아직 값 없음
	
	treelist(); // jstree 불러오기(메서드 호출)

	
	//----------------------------------------------------------------------------------------------------------------------------------
	
	
	function treelist() {
		//트리 데이터 가져오기
		$.ajax({
			type : 'post', // 메서드 방식
			url : '/treelist.do', // 요청이 전송될 url (HomeController에 jqAcademyTree()에 요청이 전송될 것)
			dataType : 'json', // 서버로 부터 받은 데이터 타입 지정
			
			// HomeController에 jqAcademyTree() return값이 곧 data가 됨
			success : function(data) { // AJAX 요청이 성공했을 때 실행될 콜백 함수를 지정
								
				console.log(data); //콘솔 출력
				
				var academy = new Array(); // academy 라는 변수로 새로운 배열 생성
				
				// 데이터 받아옴
				// 이 코드는 JavaScript 라이브러리인 jQuery의 $.each() 함수를 사용하여 
				// 배열(data)의 각 요소에 대해 반복하면서 새로운 배열(academy)을 만드는 코드입니다.
				$.each(data, function(idx, item) {
					// 각 요소에서 id, parentId, name을 추출하여 새로운 객체를 만들어 배열 academy에 추가
					academy[idx] = {
						id : item.id, //item.id -> DB에 있는 컬럼값
						parent : item.parentId, //item.parentId -> DB에 있는 컬럼값
						text : item.name //item.name -> DB에 있는 컬럼값
					}; // academy[idx] 끝
				}); //each 끝

				
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
					console.log("Selected data:", data);
					console.log("이름 : ", data.node.text);

					// Toast UI Grid 생성 및 표시
					// grid 틀 생성
					createGrid(); // 메서드 호출
					
					var clickData = { //하단에 getGridData()에 지정할 변수값
						id: 1
					}
					
					getGridData(1);
					
				}); // select_node.jstree 끝
				
			}, // success 끝
			
			
			error : function(xhr, status, error) {
				console.error('AJAX 오류:', status, error);
				
			}
		}); //ajax 끝
	} // treelist() 끝
	
	
	
	
	//----------------------------------------------------------------------------------------------------------------------------------
	
	
	
	// Grid 틀 생성
	function createGrid() {
		if(grid != null) { //grid가 존재한다면
			grid.destroy(); //파괴
		}
		
		
		//상단에 전역변수로 var grid = null; 선언해주었고, 이제 값 들어감~~
		grid = new tui.Grid({
			el : document.getElementById('grid-container'),
			scrollX : false,
			scrollY : false,
			// name이 자바 변수이름과 같아야함
			columns : [ {
				header : '번호',
				name : 'stId'
			}, {
				header : '이름',
				name : 'stName'
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
		
		
		//----------------------------------------------------------------------------------------------------------------------------------
		
		
		tui.Grid.applyTheme('striped', { // 테마 설정
		    cell: {
		        head: {
		            background: '#eef'
		        },
		        evenRow: {
		            background: '#fee'
		        }
		    }
		});
		
		
		//----------------------------------------------------------------------------------------------------------------------------------
		
		
		// afterChange 이벤트 핸들러
		grid.on('afterChange', function(ev) {
			console.log('after change:', ev);

			var changes = ev.changes;
			var rowKey = changes[0].rowKey + 1; //+1 해주는 이유는 컬럼명이 0번째를 차지하고 있기 때문..
			var columnName = changes[0].columnName;
			var value = changes[0].value;

			var student = {
				stId : rowKey,
				columnName : columnName,
				value : value,
			};

			console.log('student:', student);
			
			// afterChange를 통해서 수정된 데이터를 서버로 전송
			$.ajax({
				url : '/grid/gridUpdate', //GridController의 grid02Update()로 요청
				type : 'POST',
				contentType : 'application/json', //서버에 전송되는 데이터의 타입을 지정
				data : JSON.stringify(student), //자바스크립트의 값을 JSON 문자열로 변환
				success : function(response) {
					console.log(response);
				},
				error : function(xhr, status, error) {
					console.error('AJAX 오류:', status, error);
				}
			});
		});
	} //createGrid() 끝

	
	
	//----------------------------------------------------------------------------------------------------------------------------------
	
	
	
	function getGridData(clickData) {
		$.ajax({
			url : '/grid/getGridData', //GridController의 getGridData()로 요청
			type : 'POST', //메서드 방식
			contentType : 'application/json', //서버에 전송되는 데이터의 타입을 지정
			data : JSON.stringify(clickData), //자바스크립트의 값을 JSON 문자열로 변환
			dataType : 'json', //서버로부터 받은 데이터의 타입을 지정
			success : function(response) {
				console.log(response);
				grid.resetData(response); //grid에 데이터 받아온 값 데이터 지정
			},
			error : function(xhr, status, error) {
				console.error('AJAX 오류:', status, error);
			}
		});
	}
	
	
}); //전체 function 끝




</script>
</body>
</html>
