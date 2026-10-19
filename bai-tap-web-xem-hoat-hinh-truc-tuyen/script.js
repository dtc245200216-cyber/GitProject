// Demo: nội dung công khai; lượt xem là dữ liệu mô phỏng, không phải số liệu YouTube trực tiếp.
const films = [
 {id:"hoat-hinh-giao-duc",title:"Hoạt hình thiếu nhi – Giáo dục trẻ em",description:"Video hoạt hình giáo dục trẻ em bằng tiếng Việt được một trang trường mầm non giới thiệu.",type:"youtube",videoId:"AtoYhKkSLgQ",published:"2021-05-09",demoViews:9300,source:"Nguồn: YouTube, được giới thiệu bởi Mầm non Thạch Cầu.",emoji:"🎨"},
 {id:"em-va-chua-giesu",title:"Em và Chúa Giêsu – Thánh lễ (Tập 5)",description:"Video hoạt hình lồng tiếng Việt; nội dung giáo dục tôn giáo cho trẻ em, phù hợp khi gia đình lựa chọn.",type:"youtube",videoId:"5GCwSibKW1w",published:"2022-03-15",demoViews:7400,source:"Nguồn: YouTube, thông tin do Giáo phận Ban Mê Thuột giới thiệu.",emoji:"🌟"},
 {id:"video-html5",title:"Video HTML5 mẫu – Thiên nhiên",description:"Video phong cảnh minh họa cho cách sử dụng thẻ video HTML5 (không phải phim hoạt hình).",type:"html5",url:"https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4",published:"2020-01-01",demoViews:1900,source:"Nguồn: MDN, video minh họa HTML5.",emoji:"🌻"}
];
const search=document.querySelector("#search"), sort=document.querySelector("#sort"), list=document.querySelector("#video-list"),frame=document.querySelector("#player-container");
let selected=films[0].id;
function setFilm(film){
 selected=film.id;
 frame.replaceChildren();
 if(film.type==="youtube"){
   const player=document.createElement("iframe");
   player.src="https://www.youtube-nocookie.com/embed/"+film.videoId+"?rel=0";
   player.title=film.title;
   player.allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share";
   player.allowFullscreen=true;
   player.referrerPolicy="strict-origin-when-cross-origin";
   frame.append(player);
 }else{
   const video=document.createElement("video");
   video.controls=true;video.preload="metadata";video.playsInline=true;
   const source=document.createElement("source");source.src=film.url;source.type="video/mp4";video.append(source);
   frame.append(video);
 }
 document.querySelector("#current-title").textContent=film.title;
 document.querySelector("#current-description").textContent=film.description;
 document.querySelector("#source-note").textContent=film.source;
 renderList();
}
function renderList(){
 const q=search.value.trim().toLocaleLowerCase("vi");
 const items=films.filter(x=>x.title.toLocaleLowerCase("vi").includes(q));
 items.sort((a,b)=>sort.value==="popular"?b.demoViews-a.demoViews:sort.value==="az"?a.title.localeCompare(b.title,"vi"):b.published.localeCompare(a.published));
 list.replaceChildren();document.querySelector("#result-count").textContent=items.length+" nội dung";
 document.querySelector("#empty").hidden=items.length!==0;
 items.forEach(film=>{
   const btn=document.createElement("button");btn.type="button";btn.className="video-item"+(film.id===selected?" active":"");btn.setAttribute("aria-pressed",String(film.id===selected));
   const thumb=document.createElement("span");thumb.className="thumb thumb-emoji";thumb.textContent=film.emoji;
   const info=document.createElement("span");
   const title=document.createElement("strong");title.textContent=film.title;
   const subtitle=document.createElement("small");subtitle.textContent=film.type==="youtube"?"Video YouTube":"Video HTML5";info.append(title,subtitle);btn.append(thumb,info);
   btn.addEventListener("click",()=>setFilm(film));list.append(btn);
 });
}
search.addEventListener("input",renderList);sort.addEventListener("change",renderList);setFilm(films[0]);