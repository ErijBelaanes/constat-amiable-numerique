import {
    LayoutGrid,
    FileText,
    Car
} from "lucide-react";  //Importation des icônes
export default function Sidebar({page, setPage, apiUrl, setApiUrl, onRefresh, isDemoMode}){
    const navItems = [
        {key: "dashboard", label: "Tableau de bord", icon: LayoutGrid},
        {key: "constats", label: "Constats", icon: FileText},
    ];

    return (
        <aside
          className = "flex flex-col h-screen w-[280px] px-7 py-6"
          style = {{background: "var(--fond1)"}}
        >

          {/* Header + logo */}
          <div className="flex items-center gap-3" style={{ margin: "20px" }}>
             <div
               className="w-12 h-12 rounded-xl flex items-center justify-center"
               style={{ background: "var(--accent)" }}
             >
               <Car size={22} color="var(--text2)" />  {/* Icône de voiture */}
             </div>

            <div>
               <h1 className="m-0 text-xl font-bold" style={{ color: "var(--text2)" }}>Constat</h1>
               <p className="text-sm" style={{ color: "var(--text1)" }}>Espace admin</p>
            </div>
          </div>

          {/* Navigation */}
          <nav className="space-y-4" style={{ margin: "20px"}}>
              {navItems.map((item) => {
                const active = (page === item.key);
                const Icon = item.icon;
                return (
                  <button  //Chaque élément du tableau navItems est transformé en bouton
                     key={item.key}
                     onClick={() => setPage(item.key)}
                     className={`flex w-full items-center gap-4 rounded-md text-left transition-all duration-200 ${
                        active
                          ? "shadow-lg"  
                          : "hover:bg-white/10"
                     }`}
                     style={{
                         background: active ? "var(--accent)" : "transparent",
                         color: "white",
                         padding: "3px"
                     }}
                  >
                     <Icon size={22} />
                     <span className="text-lg">{item.label}</span>
                  </button>
                );
              })}
          </nav>
        </aside> 
    );
}