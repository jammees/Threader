"use strict";(self.webpackChunkthreader=self.webpackChunkthreader||[]).push([[703],{7866:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>d,contentTitle:()=>t,default:()=>h,frontMatter:()=>o,metadata:()=>i,toc:()=>l});var a=r(5893),s=r(1151);const o={sidebar_position:3},t=void 0,i={id:"ThreadWorker",title:"ThreadWorker",description:"ThreadWorker is a simple class that is used within a ModuleScript",source:"@site/docs/ThreadWorker.md",sourceDirName:".",slug:"/ThreadWorker",permalink:"/docs/ThreadWorker",draft:!1,unlisted:!1,tags:[],version:"current",sidebarPosition:3,frontMatter:{sidebar_position:3},sidebar:"tutorialSidebar",previous:{title:"Threader",permalink:"/docs/Threader"},next:{title:"Terrain generation",permalink:"/docs/Examples/Terrain generation"}},d={},l=[{value:"Promise",id:"promise",level:2},{value:"API",id:"api",level:2},{value:".new",id:"new",level:3},{value:":OnDispatch",id:"ondispatch",level:3},{value:":OnCancel",id:"oncancel",level:3}];function c(e){const n={a:"a",code:"code",em:"em",h2:"h2",h3:"h3",p:"p",pre:"pre",strong:"strong",...(0,s.a)(),...e.components};return(0,a.jsxs)(a.Fragment,{children:[(0,a.jsxs)(n.p,{children:["ThreadWorker is a simple class that is used within a ",(0,a.jsx)(n.em,{children:"ModuleScript"}),"\n(referenced as the ",(0,a.jsx)(n.strong,{children:"WorkerModule"}),") when passing it into the ",(0,a.jsx)(n.a,{href:"./Threader#new",children:"Threader.new()"})," constructor.\nA ThreadWorker consists of only three methods, once of which is optional."]}),"\n",(0,a.jsx)(n.h2,{id:"promise",children:"Promise"}),"\n",(0,a.jsx)(n.p,{children:"Just like in the Threader class a Promise refernce is passed into a ThreadWorker\nclass."}),"\n",(0,a.jsx)(n.h2,{id:"api",children:"API"}),"\n",(0,a.jsx)(n.h3,{id:"new",children:".new"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"ThreadWorker.new()\n"})}),"\n",(0,a.jsx)(n.p,{children:"Constructs a new ThreadWorker class. Inside of a WorkerModule:"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:'local Threader = require(game:GetService("ReplicatedStorage").Threader)\n\nlocal SumWorker = Threader.ThreadWorker.new()\n\nreturn SumWorker\n'})}),"\n",(0,a.jsx)(n.h3,{id:"ondispatch",children:":OnDispatch"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"ThreadWorker:OnDispatch(data: any)\n"})}),"\n",(0,a.jsxs)(n.p,{children:["Used to process the ",(0,a.jsx)(n.em,{children:"data"}),". Threader does not automatically desynchronize\nthe thread. Always should return the processed data to be returned to the\ncaller."]}),"\n",(0,a.jsxs)(n.p,{children:["This WorkerModule sums all of the numbers. However, what if\n",(0,a.jsxs)(n.a,{href:"./Threader#cancel",children:["Threader",":Cancel","()"]})," had been called while it was still\nworking? ",(0,a.jsx)(n.a,{href:"./ThreadWorker#oncancel",children:":OnCancel"})," is the solution for this\nproblem."]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:'local Threader = require(game:GetService("ReplicatedStorage").Threader)\n\nlocal SumWorker = Threader.ThreadWorker.new()\n\nfunction SumWorker:OnWork(data: { number })\n    task.desynchronize()\n\n    local summedNumber = 0\n\n    for _, num in data do\n        summedNumber += num\n    end\n\n    return summedNumber\nend\n\nreturn SumWorker\n'})}),"\n",(0,a.jsx)(n.h3,{id:"oncancel",children:":OnCancel"}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:"ThreadWorker:OnCancel()\n"})}),"\n",(0,a.jsxs)(n.p,{children:["Optional method, called before the thread is cancelled by calling\n",(0,a.jsxs)(n.a,{href:"./Threader#cancel",children:["Threader",":Cancel","()"]}),". Useful to stop any loops on-going\nor disconnect from certain events."]}),"\n",(0,a.jsxs)(n.p,{children:["This WorkerModule now stops summing up numbers and returns out of the\nfunction when ",(0,a.jsx)(n.em,{children:"isIterating"})," is set to false."]}),"\n",(0,a.jsx)(n.pre,{children:(0,a.jsx)(n.code,{className:"language-lua",children:'local Threader = require(game:GetService("ReplicatedStorage").Threader)\n\nlocal SumWorker = Threader.ThreadWorker.new()\n\nSumWorker.isIterating = true\n\nfunction SumWorker:OnWork(data: { number })\n    task.desynchronize()\n\n    local summedNumber = 0\n\n    for _, num in data do\n        if not self.isIterating then\n            return\n        end\n\n        summedNumber += num\n    end\n\n    return summedNumber\nend\n\nfunction SumWorker:OnCancel()\n    self.isIterating = false\nend\n\nreturn SumWorker\n'})})]})}function h(e={}){const{wrapper:n}={...(0,s.a)(),...e.components};return n?(0,a.jsx)(n,{...e,children:(0,a.jsx)(c,{...e})}):c(e)}},1151:(e,n,r)=>{r.d(n,{Z:()=>i,a:()=>t});var a=r(7294);const s={},o=a.createContext(s);function t(e){const n=a.useContext(o);return a.useMemo((function(){return"function"==typeof e?e(n):{...n,...e}}),[n,e])}function i(e){let n;return n=e.disableParentContext?"function"==typeof e.components?e.components(s):e.components||s:t(e.components),a.createElement(o.Provider,{value:n},e.children)}}}]);