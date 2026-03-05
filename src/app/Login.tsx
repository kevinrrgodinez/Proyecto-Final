import { useState } from 'react';
import { useNavigate } from 'react-router';
import { Button } from './components/ui/button';
import { Input } from './components/ui/input';
import { Label } from './components/ui/label';
import { Card, CardContent, CardHeader } from './components/ui/card';
import { Store } from 'lucide-react';

export function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    // Simple authentication - in real app would validate credentials
    const user = {
      name: 'María González',
      role: 'Cashier' as const,
      email: email,
    };
    localStorage.setItem('user', JSON.stringify(user));
    navigate('/pos');
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md shadow-lg">
        <CardHeader className="text-center space-y-4 pb-8 pt-8">
          <div className="flex justify-center">
            <div className="w-16 h-16 bg-primary rounded-2xl flex items-center justify-center">
              <Store className="w-9 h-9 text-primary-foreground" />
            </div>
          </div>
          <div>
            <h1 className="text-3xl text-primary">Ferretería Central</h1>
            <p className="text-muted-foreground mt-2">Sistema de Punto de Venta</p>
          </div>
        </CardHeader>
        <CardContent className="pb-8">
          <form onSubmit={handleLogin} className="space-y-5">
            <div className="space-y-2">
              <Label htmlFor="email">Correo Electrónico</Label>
              <Input
                id="email"
                type="email"
                placeholder="usuario@ejemplo.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
                className="h-12 bg-input-background border border-border"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">Contraseña</Label>
              <Input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
                className="h-12 bg-input-background border border-border"
              />
            </div>
            <Button type="submit" className="w-full h-12 bg-primary hover:bg-primary/90 mt-6">
              Iniciar Sesión
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
