import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router';
import { Button } from './components/ui/button';
import { Store, LogOut } from 'lucide-react';
import { User } from './types';

export function Navigation() {
  const [currentTime, setCurrentTime] = useState(new Date());
  const [user, setUser] = useState<User | null>(null);
  const navigate = useNavigate();

  useEffect(() => {
    const userData = localStorage.getItem('user');
    if (userData) {
      setUser(JSON.parse(userData));
    }

    const timer = setInterval(() => {
      setCurrentTime(new Date());
    }, 1000);

    return () => clearInterval(timer);
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('user');
    navigate('/');
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString('es-MX', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString('es-MX', {
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    });
  };

  return (
    <nav className="bg-primary text-primary-foreground shadow-md">
      <div className="max-w-[1440px] mx-auto px-6 py-4">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-4">
            <div className="w-10 h-10 bg-primary-foreground/10 rounded-lg flex items-center justify-center">
              <Store className="w-6 h-6" />
            </div>
            <div>
              <h1 className="font-semibold text-xl">Ferretería Central</h1>
              <p className="text-primary-foreground/80 text-sm">Sucursal Principal</p>
            </div>
          </div>

          <div className="flex items-center gap-8">
            <div className="text-right">
              <p className="text-sm text-primary-foreground/90">{formatDate(currentTime)}</p>
              <p className="font-semibold">{formatTime(currentTime)}</p>
            </div>

            {user && (
              <>
                <div className="h-10 w-px bg-primary-foreground/20" />
                <div className="text-right">
                  <p className="font-semibold">{user.name}</p>
                  <p className="text-sm text-primary-foreground/80">{user.role}</p>
                </div>
              </>
            )}

            <Button
              variant="ghost"
              size="sm"
              onClick={handleLogout}
              className="text-primary-foreground hover:bg-primary-foreground/10"
            >
              <LogOut className="w-4 h-4 mr-2" />
              Cerrar Sesión
            </Button>
          </div>
        </div>
      </div>
    </nav>
  );
}
