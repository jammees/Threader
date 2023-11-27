"use strict";(self.webpackChunkthreader=self.webpackChunkthreader||[]).push([[495],{9431:(e,r,n)=>{n.r(r),n.d(r,{assets:()=>l,contentTitle:()=>i,default:()=>c,frontMatter:()=>s,metadata:()=>d,toc:()=>h});var a=n(5893),t=n(1151);const s={sidebar_position:2},i=void 0,d={id:"Threader",title:"Threader",description:"Threader is a library made to extend the functionality of Actors to make working with them",source:"@site/docs/Threader.md",sourceDirName:".",slug:"/Threader",permalink:"/Threader/docs/Threader",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"tutorialSidebar",previous:{title:"Get started",permalink:"/Threader/docs/GetStarted"},next:{title:"ThreadWorker",permalink:"/Threader/docs/ThreadWorker"}},l={},h=[{value:"State",id:"state",level:2},{value:"Promise",id:"promise",level:2},{value:"ThreadWorker",id:"threadworker",level:2},{value:"API",id:"api",level:2},{value:".new",id:"new",level:3},{value:":_GenerateWorkers",id:"_generateworkers",level:3},{value:":_FragmentWorkData",id:"_fragmentworkdata",level:3},{value:":Dispatch",id:"dispatch",level:3},{value:":Cancel",id:"cancel",level:3},{value:":SetThreads",id:"setthreads",level:3},{value:":AwaitState",id:"awaitstate",level:3},{value:":Destroy",id:"destroy",level:3}];function o(e){const r={a:"a",admonition:"admonition",code:"code",em:"em",h2:"h2",h3:"h3",li:"li",p:"p",pre:"pre",strong:"strong",ul:"ul",...(0,t.a)(),...e.components};return(0,a.jsxs)(a.Fragment,{children:[(0,a.jsxs)(r.p,{children:["Threader is a library made to extend the functionality of ",(0,a.jsx)(r.code,{children:"Actors"})," to make working with them\neasier."]}),"\n",(0,a.jsxs)(r.p,{children:["When Threader had been required for the first time it will create a container\nfor all of the threads in either ",(0,a.jsx)(r.code,{children:"ServerStorage"})," or in the player's ",(0,a.jsx)(r.code,{children:"PlayerScripts"})," called ",(0,a.jsx)(r.em,{children:"_Threads"}),"."]}),"\n",(0,a.jsx)(r.h2,{id:"state",children:"State"}),"\n",(0,a.jsxs)(r.p,{children:["State is used in Threader to convey what is the library doing currently.\nIt can be either ",(0,a.jsx)(r.em,{children:"Standby"})," or ",(0,a.jsx)(r.em,{children:"Working"})," state. All of the states can\nbe accessed with ",(0,a.jsx)(r.strong,{children:"Threader.States"}),":"]}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:'Threader.States = {\n    Standby = "Standby",\n    Working = "Working",\n}\n'})}),"\n",(0,a.jsxs)(r.p,{children:["Using ",(0,a.jsx)(r.strong,{children:"Threader.States"})," is not necessary and everything can be used\nwithout it."]}),"\n",(0,a.jsx)(r.h2,{id:"promise",children:"Promise"}),"\n",(0,a.jsxs)(r.p,{children:["Threader has a reference to Promise and can be accessed with ",(0,a.jsx)(r.strong,{children:"Threader.Promise"})," for quality-of-life."]}),"\n",(0,a.jsx)(r.h2,{id:"threadworker",children:"ThreadWorker"}),"\n",(0,a.jsxs)(r.p,{children:["Reference to ",(0,a.jsx)(r.a,{href:"./ThreadWorker",children:"ThreadWorker"})," class. ThreadWorker is a simple class that is used within a ",(0,a.jsx)(r.em,{children:"workerModule"})," when\npassing it into ",(0,a.jsx)(r.code,{children:".new"}),"."]}),"\n",(0,a.jsx)(r.h2,{id:"api",children:"API"}),"\n",(0,a.jsx)(r.h3,{id:"new",children:".new"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader.new(amountThreads: number, workerModule: ModuleScript)\n"})}),"\n",(0,a.jsxs)(r.p,{children:["Constructs a new Threader class and creates a container folder for the\nthreads under the ",(0,a.jsx)(r.em,{children:"_Threads"})," folder with the name of the caller. Sets up\n",(0,a.jsx)(r.em,{children:"amountThreads"})," amount of threads."]}),"\n",(0,a.jsx)(r.h3,{id:"_generateworkers",children:":_GenerateWorkers"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:_GenerateWorkers(amountThreads: number)\n"})}),"\n",(0,a.jsx)(r.admonition,{title:"Private",type:"danger",children:(0,a.jsx)(r.p,{children:"This method is used internally and is generally discouraged to use\nsuch methods, otherwise unexpected side-effects may occur during use!"})}),"\n",(0,a.jsxs)(r.p,{children:["Sets up ",(0,a.jsx)(r.em,{children:"amountThreads"})," amount of threads."]}),"\n",(0,a.jsx)(r.h3,{id:"_fragmentworkdata",children:":_FragmentWorkData"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:_FragmentWorkData(workData: { [any]: any })\n"})}),"\n",(0,a.jsx)(r.admonition,{title:"Private",type:"danger",children:(0,a.jsx)(r.p,{children:"This method is used internally and is generally discouraged to use\nsuch methods, otherwise unexpected side-effects may occur during use!"})}),"\n",(0,a.jsx)(r.p,{children:"Fragments the data, splitting it up based on how many threads are in-use."}),"\n",(0,a.jsx)(r.h3,{id:"dispatch",children:":Dispatch"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:Dispatch(workData: { [any]: any }): Promise\n"})}),"\n",(0,a.jsx)(r.admonition,{type:"warning",children:(0,a.jsxs)(r.p,{children:["Calling ",(0,a.jsx)(r.code,{children:":Dispatch"})," while the Threader class is already running will throw an\nerror. In later updates this behaviour might change in favour of just caching\nsaid request and waiting for the class to finish and then scheduling that work\ninstead."]})}),"\n",(0,a.jsx)(r.admonition,{title:"workData incompatibility",type:"danger",children:(0,a.jsxs)(r.p,{children:["Since Threader passes the data to threads by calling ",(0,a.jsx)(r.code,{children:":SendMessage"})," on the actors, limits\nthe kind of data that can be passed around back-and-forth. For example: a table of numbers\nis completely fine, however a table of metatables such as a Promise library will result in\nan error. ",(0,a.jsxs)(r.strong,{children:["Only pass ",(0,a.jsx)(r.em,{children:"workData"})," tables that only contain primitive or serializable values"]}),"."]})}),"\n",(0,a.jsxs)(r.p,{children:["Starts the processing of the data specified in ",(0,a.jsx)(r.em,{children:"workData"}),". The ",(0,a.jsx)(r.em,{children:"workData"}),"\nmust always be a table and generally structured to be easily groupped together. Reason is, Threader always fragments it to be distributed across all of the threads currently set either by ",(0,a.jsx)(r.code,{children:".new"})," or ",(0,a.jsx)(r.code,{children:":SetThreads"}),". Returns\na Promise that will resolve once all of the threads have completed their jobs\nor one encountered an error."]}),"\n",(0,a.jsxs)(r.p,{children:["When calling ",(0,a.jsx)(r.code,{children:":Cancel"})," while the Threader class is running will result in\nthe Promise rejecting, not returning the data that was done before the\ncall."]}),"\n",(0,a.jsx)(r.h3,{id:"cancel",children:":Cancel"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:Cancel()\n"})}),"\n",(0,a.jsx)(r.admonition,{type:"warning",children:(0,a.jsxs)(r.p,{children:["Calling ",(0,a.jsx)(r.code,{children:":Cancel"})," while the Threader class is already running will yield the\ncurrent thread until the state will equal to ",(0,a.jsx)(r.strong,{children:"Threader.States.Standby"}),"!"]})}),"\n",(0,a.jsxs)(r.p,{children:["Cancels the current Threader class if the state is ",(0,a.jsx)(r.strong,{children:"Threader.States.Working"}),". Else it will return with\nno errors. Sets the current state to ",(0,a.jsx)(r.strong,{children:"Threader.States.Standby"})," if successful."]}),"\n",(0,a.jsx)(r.h3,{id:"setthreads",children:":SetThreads"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:SetThreads(amountThreads: number)\n"})}),"\n",(0,a.jsxs)(r.p,{children:["Sets the availabe threads to ",(0,a.jsx)(r.em,{children:"amountThreads"}),". If the delta\nbetween the current amount and the new amount is:"]}),"\n",(0,a.jsxs)(r.ul,{children:["\n",(0,a.jsxs)(r.li,{children:["smaller: will remove ",(0,a.jsx)(r.em,{children:"delta"})," amount"]}),"\n",(0,a.jsxs)(r.li,{children:["bigger: will add ",(0,a.jsx)(r.em,{children:"delta"})," amount"]}),"\n",(0,a.jsx)(r.li,{children:"equals: will return out"}),"\n"]}),"\n",(0,a.jsxs)(r.p,{children:["It is not recommended to call ",(0,a.jsx)(r.code,{children:":SetThreads"})," so often. This is becase under\nthe hood Threader re-parents those threads into the container folder or\nunder itself, destroying the ",(0,a.jsx)(r.code,{children:"workerModule"})," and disabling the handler. This\nby itself is not perfomance heavy, however calling it multiple times can add\nup!"]}),"\n",(0,a.jsxs)(r.p,{children:["Uses ",(0,a.jsx)(r.a,{href:"./Threader#_generateworkers",children:"Threader:_GenerateWorkers()"})," internally when delta is bigger."]}),"\n",(0,a.jsx)(r.h3,{id:"awaitstate",children:":AwaitState"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:AwaitState(awaitState: string): Promise\n"})}),"\n",(0,a.jsxs)(r.p,{children:["When called will return a ",(0,a.jsx)(r.code,{children:"Promise"})," that will resolve once the\nstate equals to ",(0,a.jsx)(r.code,{children:"awaitState"}),"."]}),"\n",(0,a.jsx)(r.h3,{id:"destroy",children:":Destroy"}),"\n",(0,a.jsx)(r.pre,{children:(0,a.jsx)(r.code,{className:"language-lua",children:"Threader:Destroy()\n"})}),"\n",(0,a.jsx)(r.p,{children:"Destroys the Threader class."})]})}function c(e={}){const{wrapper:r}={...(0,t.a)(),...e.components};return r?(0,a.jsx)(r,{...e,children:(0,a.jsx)(o,{...e})}):o(e)}},1151:(e,r,n)=>{n.d(r,{Z:()=>d,a:()=>i});var a=n(7294);const t={},s=a.createContext(t);function i(e){const r=a.useContext(s);return a.useMemo((function(){return"function"==typeof e?e(r):{...r,...e}}),[r,e])}function d(e){let r;return r=e.disableParentContext?"function"==typeof e.components?e.components(t):e.components||t:i(e.components),a.createElement(s.Provider,{value:r},e.children)}}}]);